import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Chế độ học thông minh",
      items: ["Pomodoro", "Chặn thông báo"],
    );
  }
}
