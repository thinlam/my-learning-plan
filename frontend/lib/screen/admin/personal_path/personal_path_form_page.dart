import 'package:flutter/material.dart';

class PersonalPathFormPage extends StatelessWidget {
  final String title;
  final String? studentName;
  final String? progress;

  const PersonalPathFormPage({
    super.key,
    required this.title,
    this.studentName,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final nameC = TextEditingController(text: studentName ?? "");
    final subjectC = TextEditingController();
    final noteC = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(title: Text(title), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Input(label: "Tên học sinh", controller: nameC),
            _Input(label: "Môn học trọng tâm", controller: subjectC),
            _Input(
              label: "Ghi chú / Điều chỉnh lộ trình",
              controller: noteC,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Lưu thay đổi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _Input({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
