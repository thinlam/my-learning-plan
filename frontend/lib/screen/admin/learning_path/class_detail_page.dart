import 'package:flutter/material.dart';

class ClassDetailPage extends StatelessWidget {
  final String subject;
  final String grade;

  const ClassDetailPage({
    super.key,
    required this.subject,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: Text("$subject – Khối $grade"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ActionCard(
            icon: Icons.map,
            title: "Lộ trình học chung",
            subtitle: "Áp dụng cho toàn khối",
          ),
          _ActionCard(
            icon: Icons.edit_calendar,
            title: "Lộ trình cá nhân hóa",
            subtitle: "Theo từng học sinh",
          ),
          _ActionCard(
            icon: Icons.people,
            title: "Danh sách học sinh",
            subtitle: "Theo dõi tiến độ học tập",
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
