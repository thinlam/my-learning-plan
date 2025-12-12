import 'package:flutter/material.dart';
import '../base/admin_base_page.dart';

class AdminMaterialPage extends StatelessWidget {
  const AdminMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Học liệu",
      items: ["Video bài giảng", "Bài tập luyện tập", "Đề cương ôn tập"],
    );
  }
}
