import 'package:flutter/material.dart';
import 'class_list_page.dart';

class LearningPathPage extends StatelessWidget {
  const LearningPathPage({super.key});

  void _go(BuildContext c, Widget p) {
    Navigator.push(c, MaterialPageRoute(builder: (_) => p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Quản lý lộ trình theo môn"),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ===== HEADER =====
          const Text(
            "Danh sách môn học",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Chọn môn học để quản lý lộ trình và các lớp học tương ứng",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 16),

          /// ===== SEARCH (UI ONLY) =====
          TextField(
            decoration: InputDecoration(
              hintText: "Tìm môn học...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ===== SUBJECT LIST =====
          _SubjectCard(
            subject: "Toán",
            icon: Icons.calculate,
            classes: "Lớp 10 – 11 – 12",
            students: "≈ 320 học sinh",
            onTap: () => _go(context, const ClassListPage(subject: "Toán")),
          ),
          _SubjectCard(
            subject: "Ngữ Văn",
            icon: Icons.menu_book,
            classes: "Lớp 10 – 11 – 12",
            students: "≈ 280 học sinh",
            onTap: () => _go(context, const ClassListPage(subject: "Ngữ Văn")),
          ),
          _SubjectCard(
            subject: "Tiếng Anh",
            icon: Icons.language,
            classes: "Lớp 10 – 11 – 12",
            students: "≈ 350 học sinh",
            onTap: () =>
                _go(context, const ClassListPage(subject: "Tiếng Anh")),
          ),
        ],
      ),
    );
  }
}

/// ================= SUBJECT CARD =================
class _SubjectCard extends StatelessWidget {
  final String subject;
  final IconData icon;
  final String classes;
  final String students;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.icon,
    required this.classes,
    required this.students,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.indigo, size: 28),
            ),
            const SizedBox(width: 16),

            /// INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classes,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    students,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
