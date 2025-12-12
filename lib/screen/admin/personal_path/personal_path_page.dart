import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class PersonalPathPage extends StatelessWidget {
  const PersonalPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Chỉnh sửa lộ trình cá nhân",
      items: ["Nguyễn Văn A – 70%", "Trần Thị B – 85%"],
    );
  }
}
