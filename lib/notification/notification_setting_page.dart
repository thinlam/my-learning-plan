import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool studyReminder = true;
  bool dailySummary = true;
  bool weakWarning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          "Cài đặt thông báo",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _switchTile(
            title: "Nhắc học bài",
            subtitle: "Gửi thông báo khi bạn chưa học trong ngày.",
            value: studyReminder,
            onChanged: (v) => setState(() => studyReminder = v),
          ),
          _switchTile(
            title: "Tổng kết mỗi ngày",
            subtitle: "Nhận báo cáo ngắn vào cuối ngày.",
            value: dailySummary,
            onChanged: (v) => setState(() => dailySummary = v),
          ),
          _switchTile(
            title: "Cảnh báo khi học ít",
            subtitle: "Thông báo khi thời gian học giảm nhiều.",
            value: weakWarning,
            onChanged: (v) => setState(() => weakWarning = v),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: Colors.teal),
        ],
      ),
    );
  }
}
