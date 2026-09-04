import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../models/expense_transaction_model.dart';

/// Contract for local storage operations of the Expense Tracker.
abstract class ExpenseLocalDataSource {
  Future<List<ExpenseTransactionModel>> getTransactions();
  Future<void> saveTransaction(ExpenseTransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  static const String _fileName = 'expenses_store.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  @override
  Future<List<ExpenseTransactionModel>> getTransactions() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      final list = jsonList
          .map((e) => ExpenseTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Sort by date descending (newest first)
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    } catch (e) {
      throw DatabaseException('Failed to read transactions from disk: $e');
    }
  }

  @override
  Future<void> saveTransaction(ExpenseTransactionModel transaction) async {
    try {
      final list = await getTransactions();
      final index = list.indexWhere((t) => t.id == transaction.id);

      if (index >= 0) {
        list[index] = transaction;
      } else {
        list.add(transaction);
      }

      list.sort((a, b) => b.date.compareTo(a.date));

      final file = await _getFile();
      final jsonList = list.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      throw DatabaseException('Failed to save transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final list = await getTransactions();
      list.removeWhere((t) => t.id == id);

      final file = await _getFile();
      final jsonList = list.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      throw DatabaseException('Failed to delete transaction: $e');
    }
  }
}
