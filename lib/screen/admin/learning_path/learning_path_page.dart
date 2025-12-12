import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class LearningPathPage extends StatelessWidget {
  const LearningPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      title: "Quản lý lộ trình học",
      items: const ["Toán 12", "Văn 11", "Anh 10"],
      onAdd: () {},
    );
  }
}
