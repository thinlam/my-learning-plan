import 'package:flutter/material.dart';
import 'personal_path_form_page.dart';

class PersonalPathPage extends StatefulWidget {
  const PersonalPathPage({super.key});

  @override
  State<PersonalPathPage> createState() => _PersonalPathPageState();
}

class _PersonalPathPageState extends State<PersonalPathPage> {
  final List<Map<String, String>> students = [
    {"name": "Nguyễn Văn A", "progress": "70%"},
    {"name": "Trần Thị B", "progress": "85%"},
    {"name": "Lê Văn C", "progress": "60%"},
  ];

  void _add() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const PersonalPathFormPage(title: "Thêm lộ trình cá nhân"),
      ),
    );
  }

  void _edit(Map<String, String> s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalPathFormPage(
          title: "Chỉnh sửa lộ trình cá nhân",
          studentName: s["name"],
          progress: s["progress"],
        ),
      ),
    );
  }

  void _delete(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa lộ trình"),
        content: Text("Xóa lộ trình cá nhân của $name?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Lộ trình cá nhân hóa"),
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
          return _PersonalPathCard(
            name: s["name"]!,
            progress: s["progress"]!,
            onEdit: () => _edit(s),
            onDelete: () => _delete(s["name"]!),
          );
        }).toList(),
      ),
    );
  }
}

class _PersonalPathCard extends StatelessWidget {
  final String name;
  final String progress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PersonalPathCard({
    required this.name,
    required this.progress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final percent = int.parse(progress.replaceAll("%", ""));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                    fontWeight: FontWeight.w600,
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
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          Text("Tiến độ hoàn thành: $progress"),
        ],
      ),
    );
  }
}
