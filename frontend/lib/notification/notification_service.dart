import 'notification_model.dart';

class NotificationService {
  static final List<AppNotification> _notifications = [
    AppNotification(
      id: "1",
      title: "Nhắc học bài 📚",
      message: "Hôm nay bạn chưa hoàn thành bài học nào. Hãy xem lộ trình nhé!",
      time: DateTime.now().subtract(const Duration(minutes: 20)),
      type: "reminder",
    ),
    AppNotification(
      id: "2",
      title: "Tiến độ tuần",
      message: "Bạn đã hoàn thành 72% mục tiêu tuần này. Tuyệt lắm!",
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: "progress",
    ),
    AppNotification(
      id: "3",
      title: "Cảnh báo ⚠️",
      message: "Thời gian học của bạn giảm 40% so với tuần trước.",
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: "warning",
    ),
  ];

  static List<AppNotification> getNotifications() {
    return _notifications;
  }

  static void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  static void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}
