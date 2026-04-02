import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_model.dart';
import 'notification_service.dart';
import '../notification/notification_setting_page.dart';

// Các trang điều hướng khi nhấn thông báo
import '../../progress/progress_page.dart';
import '../../learning_path/page/path_selection_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<AppNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = NotificationService.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Thông báo",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: notifications.map((n) => _notificationTile(n)).toList(),
      ),
    );
  }

  /// ===============================
  ///   TILE CÓ THỂ BẤM ĐƯỢC
  /// ===============================
  Widget _notificationTile(AppNotification n) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // đánh dấu đã đọc
        setState(() {
          NotificationService.markAsRead(n.id);
        });

        // điều hướng theo loại thông báo
        _navigateByType(n);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white : Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(_iconForType(n.type), color: Colors.teal, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.message,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(n.time),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================================================
  ///  Điều hướng theo loại thông báo
  /// ===================================================
  void _navigateByType(AppNotification n) {
    if (n.type == "reminder") {
      // Nhắc học bài → Mở Lộ trình
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PathSelectionPage()),
      );
    } else if (n.type == "progress") {
      // Tiến độ tuần → Mở trang Progress
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProgressPage()),
      );
    } else if (n.type == "warning") {
      // Cảnh báo → Bạn có thể tạo page riêng, tạm để Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tính năng cảnh báo đang được phát triển"),
        ),
      );
    }
  }

  /// Loại icon theo kiểu thông báo
  IconData _iconForType(String type) {
    switch (type) {
      case "reminder":
        return Icons.access_time_filled;
      case "warning":
        return Icons.warning_rounded;
      case "progress":
        return Icons.show_chart_rounded;
      default:
        return Icons.notifications;
    }
  }

  /// Format thời gian: "20 phút trước"
  String _formatTime(DateTime t) {
    Duration diff = DateTime.now().difference(t);

    if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
    if (diff.inHours < 24) return "${diff.inHours} giờ trước";

    return "${diff.inDays} ngày trước";
  }
}
