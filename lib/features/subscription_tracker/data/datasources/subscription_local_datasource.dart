import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionLocalDataSource {
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<void> saveSubscription(SubscriptionModel model);
  Future<void> deleteSubscription(String id);
  Future<void> toggleSubscriptionStatus(String id);
}

class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  static const String _fileName = 'subscriptions_store.json';
  File? _cachedFile;

  Future<File> _getFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedFile = File('${dir.path}/$_fileName');
    return _cachedFile!;
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to read subscriptions from local storage: $e');
    }
  }

  @override
  Future<void> saveSubscription(SubscriptionModel model) async {
    try {
      final items = await getSubscriptions();
      final index = items.indexWhere((item) => item.id == model.id);
      if (index >= 0) {
        items[index] = model;
      } else {
        items.add(model);
      }
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to save subscription: $e');
    }
  }

  @override
  Future<void> deleteSubscription(String id) async {
    try {
      final items = await getSubscriptions();
      items.removeWhere((item) => item.id == id);
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to delete subscription: $e');
    }
  }

  @override
  Future<void> toggleSubscriptionStatus(String id) async {
    try {
      final items = await getSubscriptions();
      final index = items.indexWhere((item) => item.id == id);
      if (index >= 0) {
        final current = items[index];
        items[index] = SubscriptionModel(
          id: current.id,
          name: current.name,
          amount: current.amount,
          currency: current.currency,
          billingCycle: current.billingCycle,
          nextBillingDate: current.nextBillingDate,
          category: current.category,
          remindDaysBefore: current.remindDaysBefore,
          isActive: !current.isActive,
          notes: current.notes,
        );
        await _persist(items);
      }
    } catch (e) {
      throw DatabaseException('Failed to toggle subscription status: $e');
    }
  }

  Future<void> _persist(List<SubscriptionModel> items) async {
    final file = await _getFile();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
