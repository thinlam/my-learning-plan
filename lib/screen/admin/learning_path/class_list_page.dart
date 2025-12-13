import 'package:flutter/material.dart';
import 'class_detail_page.dart';

class ClassListPage extends StatelessWidget {
  final String subject;
  const ClassListPage({super.key, required this.subject});

  void _go(BuildContext c, Widget p) {
    Navigator.push(c, MaterialPageRoute(builder: (_) => p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: Text("Môn $subject"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Danh sách khối",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Chọn khối để quản lý lộ trình học và học sinh",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _GradeCard(
            grade: "Khối 10",
            students: "≈ 120 học sinh",
            onTap: () =>
                _go(context, ClassDetailPage(subject: subject, grade: "10")),
          ),
          _GradeCard(
            grade: "Khối 11",
            students: "≈ 100 học sinh",
            onTap: () =>
                _go(context, ClassDetailPage(subject: subject, grade: "11")),
          ),
          _GradeCard(
            grade: "Khối 12",
            students: "≈ 140 học sinh",
            onTap: () =>
                _go(context, ClassDetailPage(subject: subject, grade: "12")),
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final String grade;
  final String students;
  final VoidCallback onTap;

  const _GradeCard({
    required this.grade,
    required this.students,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.indigo),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    students,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
