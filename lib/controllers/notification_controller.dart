import 'dart:async';

import 'package:get/get.dart';

import '../data/models/notification_model.dart';
import '../data/models/order_model.dart';
import '../data/models/user_model.dart';
import '../data/services/notification_service.dart';
import 'login_controller.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  StreamSubscription<List<OrderModel>>? _sub;
  final Map<String, String> _knownStatuses = {};
  String? _currentUserId;

  late AuthController authController;

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
    bindToUser(authController.currentUser);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> bindToUser(UserModel? user) async {
    await _sub?.cancel();
    _sub = null;

    _knownStatuses.clear();
    notifications.clear();
    unreadCount.value = 0;
    _currentUserId = user?.id;

    final userId = user?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    _knownStatuses.addAll(await _service.loadKnownStatuses(userId));

    final savedNotifications = await _service.loadStoredNotifications(userId);
    savedNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifications.assignAll(savedNotifications);
    _refreshUnreadCount();

    _sub = _service.watchUserOrders(userId).listen((orders) async {
      final mergedNotifications = List<NotificationModel>.from(notifications);
      var hasNewNotifications = false;
      var statusCacheChanged = false;

      for (final order in orders) {
        final previousStatus = _knownStatuses[order.docId];
        if (previousStatus != null && previousStatus != order.orderStatus) {
          final newNotification = NotificationModel(
            id: '${order.docId}_${order.updatedAt.millisecondsSinceEpoch}',
            userId: userId,
            orderId: order.id,
            orderStatus: order.orderStatus,
            message: _buildStatusMessage(order),
            isRead: false,
            createdAt: order.updatedAt,
          );

          final alreadyExists = mergedNotifications.any(
            (item) =>
                item.orderId == newNotification.orderId &&
                item.orderStatus == newNotification.orderStatus &&
                item.createdAt == newNotification.createdAt,
          );

          if (!alreadyExists) {
            mergedNotifications.insert(0, newNotification);
            hasNewNotifications = true;
          }
        }

        if (_knownStatuses[order.docId] != order.orderStatus) {
          _knownStatuses[order.docId] = order.orderStatus;
          statusCacheChanged = true;
        }
      }

      mergedNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifications.assignAll(mergedNotifications);
      _refreshUnreadCount();

      if (statusCacheChanged) {
        await _service.saveKnownStatuses(userId, _knownStatuses);
      }
      if (hasNewNotifications) {
        await _service.saveStoredNotifications(userId, mergedNotifications);
      }
    });
  }

  Future<void> markAsRead(NotificationModel noti) async {
    if (noti.isRead) return;

    notifications.value = notifications.map((item) {
      if (item.id == noti.id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();

    _refreshUnreadCount();
    await _persistNotifications();
  }

  Future<void> markAllAsRead() async {
    notifications.value = notifications
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    _refreshUnreadCount();
    await _persistNotifications();
  }

  String _buildStatusMessage(OrderModel order) {
    final statusLabel = order.orderStatus.replaceAll('_', ' ').trim();
    return 'Đơn hàng ${order.id} đã cập nhật sang trạng thái $statusLabel';
  }

  void _refreshUnreadCount() {
    unreadCount.value = notifications.where((item) => !item.isRead).length;
  }

  Future<void> _persistNotifications() async {
    final userId = _currentUserId;
    if (userId == null || userId.isEmpty) {
      return;
    }
    await _service.saveStoredNotifications(userId, notifications.toList());
  }
}
