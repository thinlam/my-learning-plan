import 'package:flutter/material.dart';

class AdminFormPage extends StatelessWidget {
  final String title;

  const AdminFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            TextField(decoration: InputDecoration(labelText: "Tên")),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: "Mô tả")),
            SizedBox(height: 24),
            ElevatedButton(onPressed: null, child: Text("Lưu")),
          ],
        ),
      ),
    );
  }
}
