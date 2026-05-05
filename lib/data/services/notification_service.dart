import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../models/order_model.dart';

class NotificationService {
  final _db = FirebaseFirestore.instance;

  static const _notificationsPrefix = 'local_notifications_';
  static const _statusCachePrefix = 'order_status_cache_';

  Stream<List<OrderModel>> watchUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'docId': doc.id}))
          .toList();
      orders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return orders;
    });
  }

  Future<List<NotificationModel>> loadStoredNotifications(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_notificationsPrefix$userId');
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => NotificationModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveStoredNotifications(
    String userId,
    List<NotificationModel> notifications,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(notifications.map((item) => item.toMap()).toList());
    await prefs.setString('$_notificationsPrefix$userId', raw);
  }

  Future<Map<String, String>> loadKnownStatuses(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_statusCachePrefix$userId');
    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(key, value?.toString() ?? ''),
    );
  }

  Future<void> saveKnownStatuses(
    String userId,
    Map<String, String> statuses,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_statusCachePrefix$userId', jsonEncode(statuses));
  }
}
