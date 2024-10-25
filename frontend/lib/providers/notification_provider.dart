import 'package:flutter/material.dart';
import 'package:frontend/models/notification_model.dart';
import 'package:frontend/services/notificationList_service.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notificationList = []; // 알림 리스트 저장 변수

  List<NotificationModel> get notificationList =>
      _notificationList; // 저장된 알림 리스트 호출 메서드

  Future<void> fetchNotification() async {
    List<NotificationModel> getNotificationList =
        await NotificationListService().fetchNotification();

    _notificationList.clear(); // 재호출 시 배로 더 많아지는 현상 방지

    for (var notification in getNotificationList) {
      _notificationList.add(notification);
    }
    notifyListeners(); // setState 역할
  }
}
