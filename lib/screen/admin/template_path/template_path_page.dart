import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class TemplatePathPage extends StatelessWidget {
  const TemplatePathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Bộ lộ trình mẫu",
      items: ["Ôn thi", "Học hằng ngày", "Học thêm"],
    );
  }
}
