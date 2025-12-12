import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(
      title: "Cộng đồng học tập",
      items: ["Nhóm Toán", "Thi đua tuần"],
    );
  }
}
