import 'package:flutter/material.dart';

class AdminMaterialPage extends StatelessWidget {
  const AdminMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Học liệu"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _MaterialCard(
            title: "Video bài giảng",
            subtitle: "Toán – Văn – Anh",
            icon: Icons.play_circle_fill,
          ),
          _MaterialCard(
            title: "Bài tập luyện tập",
            subtitle: "Bài tập theo chương",
            icon: Icons.assignment,
          ),
          _MaterialCard(
            title: "Đề cương ôn tập",
            subtitle: "Ôn thi học kỳ / đại học",
            icon: Icons.menu_book,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _MaterialCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

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
      child: Row(
        children: [
          Icon(icon, size: 36, color: Colors.indigo),
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
