class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final String type; // study / reminder / warning / progress / system

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type = "system",
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
