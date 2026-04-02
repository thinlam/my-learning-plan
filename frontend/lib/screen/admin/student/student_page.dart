import 'package:flutter/material.dart';
import 'student_detail_page.dart';
import 'student_form_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Map<String, dynamic>> students = [
    {"name": "Nguyễn Văn A", "class": "12A1", "progress": 80},
    {"name": "Trần Thị B", "class": "11B2", "progress": 65},
    {"name": "Lê Văn C", "class": "10C3", "progress": 90},
  ];

  void _add() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentFormPage(title: "Thêm học sinh"),
      ),
    );
  }

  void _edit(Map<String, dynamic> s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormPage(
          title: "Chỉnh sửa học sinh",
          initName: s["name"],
          initClass: s["class"],
        ),
      ),
    );
  }

  void _delete(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa học sinh"),
        content: Text("Bạn có chắc muốn xóa $name không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                students.removeWhere((e) => e["name"] == name);
              });
              Navigator.pop(context);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  void _detail(Map<String, dynamic> s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailPage(
          name: s["name"],
          className: s["class"],
          progress: s["progress"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Quản lý học sinh"),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: students.map((s) {
          return _StudentCard(
            name: s["name"],
            className: s["class"],
            progress: s["progress"],
            onTap: () => _detail(s),
            onEdit: () => _edit(s),
            onDelete: () => _delete(s["name"]),
          );
        }).toList(),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final String className;
  final int progress;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.name,
    required this.className,
    required this.progress,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Lớp: $className"),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade200,
              color: Colors.indigo,
            ),
            const SizedBox(height: 6),
            Text("Tiến độ học tập: $progress%"),
          ],
        ),
      ),
    );
  }
}
