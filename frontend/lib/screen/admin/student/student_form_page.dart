import 'package:flutter/material.dart';

class StudentFormPage extends StatelessWidget {
  final String title;
  final String? initName;
  final String? initClass;

  const StudentFormPage({
    super.key,
    required this.title,
    this.initName,
    this.initClass,
  });

  @override
  Widget build(BuildContext context) {
    final nameC = TextEditingController(text: initName ?? "");
    final classC = TextEditingController(text: initClass ?? "");

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(title: Text(title), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Input(label: "Tên học sinh", controller: nameC),
            _Input(label: "Lớp", controller: classC),
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

  const _Input({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
