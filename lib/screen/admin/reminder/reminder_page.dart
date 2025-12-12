import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Nhắc lịch thông minh",
      items: ["Nhắc Toán", "Nhắc Anh"],
    );
  }
}
