import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Cảnh báo học tập"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AlertIntroCard(),
          SizedBox(height: 20),

          _AlertTypeCard(
            title: "Học quá ít",
            description:
                "Cảnh báo khi học sinh học dưới số giờ tối thiểu trong tuần.",
            icon: Icons.trending_down,
            color: Colors.orange,
          ),
          _AlertTypeCard(
            title: "Học quá khuya",
            description: "Phát hiện học sinh học sau 23h nhiều ngày liên tiếp.",
            icon: Icons.nightlight_round,
            color: Colors.deepPurple,
          ),
          _AlertTypeCard(
            title: "Bỏ lộ trình",
            description: "Học sinh không học theo lộ trình trong nhiều ngày.",
            icon: Icons.warning_amber,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _AlertIntroCard extends StatelessWidget {
  const _AlertIntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hệ thống cảnh báo học tập",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Tự động phát hiện các dấu hiệu học tập không hiệu quả "
            "để Admin và học sinh kịp thời điều chỉnh lộ trình.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AlertTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _AlertTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  State<_AlertTypeCard> createState() => _AlertTypeCardState();
}

class _AlertTypeCardState extends State<_AlertTypeCard> {
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
          /// Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color),
              ),
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
                activeTrackColor: widget.color,
                onChanged: (v) => setState(() => enabled = v),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            widget.description,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text("Danh sách HS"),
                  onPressed: () => _showStudents(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text("Cấu hình"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                  ),
                  onPressed: () => _showConfig(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===== Dialog: danh sách học sinh bị cảnh báo
  void _showStudents(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Học sinh bị cảnh báo"),
        content: const Text(
          "- Nguyễn Văn A\n"
          "- Trần Thị B\n"
          "- Lê Văn C\n\n"
          "(Dữ liệu mô phỏng)",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  /// ===== Dialog: cấu hình cảnh báo
  void _showConfig(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cấu hình cảnh báo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.timer),
              title: Text("Ngưỡng thời gian học"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Số ngày liên tiếp"),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Gửi thông báo tự động"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Xong"),
          ),
        ],
      ),
    );
  }
}
