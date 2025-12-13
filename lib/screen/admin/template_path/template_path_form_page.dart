import 'package:flutter/material.dart';

class TemplatePathFormPage extends StatelessWidget {
  final String title;
  final String? initName;
  final String? initGrade;
  final String? initDuration;
  final String? initDesc;

  const TemplatePathFormPage({
    super.key,
    required this.title,
    this.initName,
    this.initGrade,
    this.initDuration,
    this.initDesc,
  });

  @override
  Widget build(BuildContext context) {
    final nameC = TextEditingController(text: initName ?? "");
    final gradeC = TextEditingController(text: initGrade ?? "");
    final durationC = TextEditingController(text: initDuration ?? "");
    final descC = TextEditingController(text: initDesc ?? "");

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(title: Text(title), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Input(label: "Tên lộ trình", controller: nameC),
            _Input(label: "Khối lớp (10/11/12)", controller: gradeC),
            _Input(label: "Thời lượng (vd: 8 tuần)", controller: durationC),
            _Input(label: "Mô tả", controller: descC, maxLines: 3),
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
                child: const Text("Lưu"),
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
