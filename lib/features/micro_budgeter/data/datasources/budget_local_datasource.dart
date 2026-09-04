import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../models/budget_envelope_model.dart';
import '../models/expense_transaction_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetEnvelopeModel>> getEnvelopes();
  Future<void> saveEnvelope(BudgetEnvelopeModel model);
  Future<void> deleteEnvelope(String id);

  Future<List<ExpenseTransactionModel>> getTransactions(String envelopeId);
  Future<void> addTransaction(ExpenseTransactionModel model);
  Future<void> deleteTransaction(String id, String envelopeId);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  static const String _envelopesFile = 'budget_envelopes_store.json';
  static const String _transactionsFile = 'budget_transactions_store.json';

  Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  @override
  Future<List<BudgetEnvelopeModel>> getEnvelopes() async {
    try {
      final file = await _getFile(_envelopesFile);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => BudgetEnvelopeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to read budget envelopes: $e');
    }
  }

  @override
  Future<void> saveEnvelope(BudgetEnvelopeModel model) async {
    try {
      final items = await getEnvelopes();
      final index = items.indexWhere((e) => e.id == model.id);
      if (index >= 0) {
        items[index] = model;
      } else {
        items.add(model);
      }
      final file = await _getFile(_envelopesFile);
      await file.writeAsString(jsonEncode(items.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw DatabaseException('Failed to save budget envelope: $e');
    }
  }

  @override
  Future<void> deleteEnvelope(String id) async {
    try {
      final items = await getEnvelopes();
      items.removeWhere((e) => e.id == id);
      final file = await _getFile(_envelopesFile);
      await file.writeAsString(jsonEncode(items.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw DatabaseException('Failed to delete envelope: $e');
    }
  }

  @override
  Future<List<ExpenseTransactionModel>> getTransactions(String envelopeId) async {
    try {
      final file = await _getFile(_transactionsFile);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      final all = jsonList
          .map((e) => ExpenseTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return all.where((t) => t.envelopeId == envelopeId).toList();
    } catch (e) {
      throw DatabaseException('Failed to read transactions: $e');
    }
  }

  @override
  Future<void> addTransaction(ExpenseTransactionModel model) async {
    try {
      // 1. Append transaction
      final file = await _getFile(_transactionsFile);
      List<ExpenseTransactionModel> all = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> list = jsonDecode(content) as List<dynamic>;
          all = list.map((e) => ExpenseTransactionModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      all.add(model);
      await file.writeAsString(jsonEncode(all.map((e) => e.toJson()).toList()));

      // 2. Update envelope spent amount
      final envelopes = await getEnvelopes();
      final envIndex = envelopes.indexWhere((e) => e.id == model.envelopeId);
      if (envIndex >= 0) {
        final current = envelopes[envIndex];
        envelopes[envIndex] = BudgetEnvelopeModel(
          id: current.id,
          name: current.name,
          targetAmount: current.targetAmount,
          spentAmount: current.spentAmount + model.amount,
          startDate: current.startDate,
          endDate: current.endDate,
          currency: current.currency,
          category: current.category,
          isArchived: current.isArchived,
        );
        final envFile = await _getFile(_envelopesFile);
        await envFile.writeAsString(jsonEncode(envelopes.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      throw DatabaseException('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id, String envelopeId) async {
    try {
      final file = await _getFile(_transactionsFile);
      if (!await file.exists()) return;

      final content = await file.readAsString();
      if (content.trim().isEmpty) return;

      final List<dynamic> list = jsonDecode(content) as List<dynamic>;
      final all = list.map((e) => ExpenseTransactionModel.fromJson(e as Map<String, dynamic>)).toList();

      final target = all.firstWhere((t) => t.id == id, orElse: () => all.first);
      final deductedAmount = target.amount;

      all.removeWhere((t) => t.id == id);
      await file.writeAsString(jsonEncode(all.map((e) => e.toJson()).toList()));

      // Deduct from envelope spent amount
      final envelopes = await getEnvelopes();
      final envIndex = envelopes.indexWhere((e) => e.id == envelopeId);
      if (envIndex >= 0) {
        final current = envelopes[envIndex];
        envelopes[envIndex] = BudgetEnvelopeModel(
          id: current.id,
          name: current.name,
          targetAmount: current.targetAmount,
          spentAmount: (current.spentAmount - deductedAmount).clamp(0.0, double.infinity),
          startDate: current.startDate,
          endDate: current.endDate,
          currency: current.currency,
          category: current.category,
          isArchived: current.isArchived,
        );
        final envFile = await _getFile(_envelopesFile);
        await envFile.writeAsString(jsonEncode(envelopes.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      throw DatabaseException('Failed to delete transaction: $e');
    }
  }
}
