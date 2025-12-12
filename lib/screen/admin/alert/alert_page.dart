import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Cảnh báo học tập",
      items: ["Học ít", "Học khuya"],
    );
  }
}
