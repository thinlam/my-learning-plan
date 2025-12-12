import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "AI gợi ý lộ trình",
      items: ["AI Toán", "AI Văn"],
    );
  }
}
