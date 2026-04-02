import 'package:flutter/material.dart';

class AdminBasePage extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback? onAdd;

  const AdminBasePage({
    super.key,
    required this.title,
    required this.items,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(title: Text(title), backgroundColor: Colors.indigo),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(e)),
                    const Icon(Icons.edit, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Icon(Icons.delete, color: Colors.red),
                  ],
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
