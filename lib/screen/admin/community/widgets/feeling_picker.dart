import 'package:flutter/material.dart';

class FeelingPicker extends StatelessWidget {
  final Function(String) onSelect;

  const FeelingPicker({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final feelings = [
      "😊 Vui vẻ",
      "😢 Buồn",
      "😡 Tức giận",
      "🤩 Hào hứng",
      "😴 Mệt mỏi",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chọn cảm xúc")),
      body: ListView(
        children: feelings
            .map(
              (f) => ListTile(
                title: Text(f),
                onTap: () {
                  onSelect(f);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
