import 'package:flutter/material.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("AI gợi ý lộ trình"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AIDescriptionCard(),
          SizedBox(height: 20),

          _AIModuleCard(
            subject: "Toán",
            description:
                "AI phân tích tiến độ, điểm yếu – mạnh để đề xuất lộ trình Toán phù hợp.",
          ),
          _AIModuleCard(
            subject: "Văn",
            description:
                "AI điều chỉnh lịch học Văn dựa trên mức độ hoàn thành bài tập.",
          ),
          _AIModuleCard(
            subject: "Tiếng Anh",
            description:
                "AI gợi ý học từ vựng – ngữ pháp theo năng lực học sinh.",
          ),
        ],
      ),
    );
  }
}

class _AIDescriptionCard extends StatelessWidget {
  const _AIDescriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI gợi ý lộ trình học",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "AI phân tích dữ liệu học tập (tiến độ, thói quen, môn yếu – mạnh) "
            "để đề xuất và điều chỉnh lộ trình học phù hợp cho từng học sinh.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AIModuleCard extends StatefulWidget {
  final String subject;
  final String description;

  const _AIModuleCard({required this.subject, required this.description});

  @override
  State<_AIModuleCard> createState() => _AIModuleCardState();
}

class _AIModuleCardState extends State<_AIModuleCard> {
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
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smart_toy, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "AI ${widget.subject}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: enabled,
                activeThumbColor: Colors.indigo,
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
                  icon: const Icon(Icons.visibility),
                  label: const Text("Xem gợi ý"),
                  onPressed: () => _showPreview(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text("Cấu hình"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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

  /// ====== Dialog xem gợi ý (mock)
  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Gợi ý AI – ${widget.subject}"),
        content: const Text(
          "- Học 3 buổi / tuần\n"
          "- Ưu tiên bài yếu\n"
          "- Ôn tập cuối tuần\n\n"
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

  /// ====== Dialog cấu hình AI
  void _showConfig(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cấu hình AI"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Tối ưu thời gian học"),
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text("Ưu tiên môn yếu"),
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text("Điều chỉnh theo tiến độ"),
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
