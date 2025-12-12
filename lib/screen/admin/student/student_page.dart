import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Quản lý học sinh",
      items: ["HS A – Lớp 12", "HS B – Lớp 11"],
    );
  }
}
