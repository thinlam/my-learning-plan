import 'package:flutter/material.dart';
import 'package:my_learning_plan/screen/admin/material/material_page.dart';
import 'learning_path/learning_path_page.dart';
import 'personal_path/personal_path_page.dart';
import 'template_path/template_path_page.dart';
import 'student/student_page.dart';
import 'ai/ai_page.dart';
import 'reminder/reminder_page.dart';
import 'alert/alert_page.dart';
import 'report/report_page.dart';
import 'community/community_page.dart';
import 'reward/reward_page.dart';
import 'focus/focus_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _go(BuildContext c, Widget p) {
    Navigator.push(c, MaterialPageRoute(builder: (_) => p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle("Quản lý chính"),
          _AdminCard(
            icon: Icons.map,
            title: "Quản lý lộ trình học",
            subtitle: "Thêm – sửa – xóa lộ trình",
            onTap: () => _go(context, const LearningPathPage()),
          ),
          _AdminCard(
            icon: Icons.edit_calendar,
            title: "Lộ trình cá nhân hóa",
            subtitle: "Điều chỉnh theo từng học sinh",
            onTap: () => _go(context, const PersonalPathPage()),
          ),
          _AdminCard(
            icon: Icons.layers,
            title: "Bộ lộ trình mẫu",
            subtitle: "Lộ trình ôn thi – hằng ngày",
            onTap: () => _go(context, const TemplatePathPage()),
          ),
          _AdminCard(
            icon: Icons.people,
            title: "Quản lý học sinh",
            subtitle: "Theo dõi tiến độ học tập",
            onTap: () => _go(context, const StudentPage()),
          ),

          const SizedBox(height: 24),
          const _SectionTitle("AI & nâng cao"),
          _AdminCard(
            icon: Icons.smart_toy,
            title: "AI gợi ý lộ trình",
            subtitle: "Đề xuất & điều chỉnh tự động",
            onTap: () => _go(context, const AIPage()),
          ),
          _AdminCard(
            icon: Icons.notifications_active,
            title: "Nhắc lịch thông minh",
            subtitle: "Nhắc học – nhắc kiểm tra",
            onTap: () => _go(context, const ReminderPage()),
          ),
          _AdminCard(
            icon: Icons.menu_book,
            title: "Học liệu",
            subtitle: "Video – bài tập – đề cương",
            onTap: () => _go(context, const AdminMaterialPage()),
          ),
          _AdminCard(
            icon: Icons.warning_amber,
            title: "Cảnh báo học tập",
            subtitle: "Phát hiện học lệch – bỏ lộ trình",
            onTap: () => _go(context, const AlertPage()),
          ),

          const SizedBox(height: 24),
          const _SectionTitle("Hệ thống"),
          _AdminCard(
            icon: Icons.bar_chart,
            title: "Báo cáo",
            subtitle: "Tuần – tháng – tiến độ",
            onTap: () => _go(context, const ReportPage()),
          ),
          _AdminCard(
            icon: Icons.groups,
            title: "Cộng đồng học tập",
            subtitle: "Nhóm học – thi đua",
            onTap: () => _go(context, const CommunityPage()),
          ),
          _AdminCard(
            icon: Icons.emoji_events,
            title: "Phần thưởng",
            subtitle: "XP – huy hiệu – thành tích",
            onTap: () => _go(context, const RewardPage()),
          ),
          _AdminCard(
            icon: Icons.timer,
            title: "Chế độ học thông minh",
            subtitle: "Pomodoro – tập trung",
            onTap: () => _go(context, const FocusPage()),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.indigo),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
