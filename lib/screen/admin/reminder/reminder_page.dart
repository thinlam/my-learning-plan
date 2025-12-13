import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Nhắc lịch thông minh"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ReminderCard(
            title: "Nhắc học Toán",
            description: "Nhắc học trước buổi học Toán 30 phút",
            icon: Icons.calculate,
          ),
          _ReminderCard(
            title: "Nhắc ôn bài Anh",
            description: "Nhắc ôn bài tiếng Anh buổi tối",
            icon: Icons.language,
          ),
          _ReminderCard(
            title: "Nhắc trước kiểm tra",
            description: "Tự động nhắc trước ngày kiểm tra",
            icon: Icons.alarm,
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const _ReminderCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: enabled,
                onChanged: (v) => setState(() => enabled = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showConfig(context),
                  child: const Text("Cấu hình"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showStudents(context),
                  child: const Text("Danh sách HS"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfig(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Cấu hình nhắc lịch"),
        content: Text(
          "• Thời gian nhắc\n"
          "• Lặp lại theo ngày / tuần\n"
          "• Gửi thông báo đẩy",
        ),
      ),
    );
  }

  void _showStudents(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Học sinh được nhắc"),
        content: Text("- Nguyễn Văn A\n- Trần Thị B\n(Dữ liệu mô phỏng)"),
      ),
    );
  }
}
