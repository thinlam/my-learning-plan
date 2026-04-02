import '../base/admin_base_page.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminBasePage(title: "Phần thưởng", items: ["XP", "Huy hiệu"]);
  }
}
