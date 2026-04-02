import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_learning_plan/auth/login_page.dart';
import 'package:my_learning_plan/notification/notification_page.dart';
import 'package:my_learning_plan/screen/profile/edit_profile_page.dart';
import 'package:my_learning_plan/screen/settings/language_page.dart';
import 'package:my_learning_plan/screen/settings/dark_mode_page.dart';
import 'package:my_learning_plan/screen/home/Change_Password/change_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userStream =>
      FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ cá nhân")),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() ?? {};
              return _buildBody(
                data["name"] ?? "Không rõ tên",
                data["email"] ?? user?.email ?? "",
                data["avatarUrl"],
                data["lessons"] ?? 0,
                data["hours"] ?? 0,
                data["certificates"] ?? 0,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    String name,
    String email,
    String? avatar,
    int lessons,
    int hours,
    int certs,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _card(
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.2),
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        _stats(lessons, hours, certs),

        const SizedBox(height: 24),
        _section("Tài khoản"),
        _tile(
          Icons.edit,
          "Chỉnh sửa hồ sơ",
          Colors.blue,
          () => _go(const EditProfilePage()),
        ),
        _tile(
          Icons.lock,
          "Đổi mật khẩu",
          Colors.orange,
          () => _go(const ChangePassword()),
        ),

        const SizedBox(height: 20),
        _section("Cài đặt"),
        _tile(
          Icons.notifications,
          "Thông báo",
          Colors.green,
          () => _go(const NotificationsPage()),
        ),
        _tile(
          Icons.language,
          "Ngôn ngữ",
          Colors.purple,
          () => _go(const LanguagePage()),
        ),
        _tile(
          Icons.dark_mode,
          "Chế độ tối",
          Colors.grey,
          () => _go(const DarkModePage()),
        ),

        const SizedBox(height: 20),
        _section("Khác"),
        _tile(Icons.help_center, "Trung tâm hỗ trợ", Colors.indigo, () {}),
        _tile(
          Icons.privacy_tip,
          "Điều khoản & Quyền riêng tư",
          Colors.teal,
          () {},
        ),

        const SizedBox(height: 24),
        _logout(),
      ],
    );
  }

  Widget _stats(int l, int h, int c) {
    return _card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat(Icons.book, "$l", "Bài học"),
          _stat(Icons.timer, "${h}h", "Thời gian"),
          _stat(Icons.emoji_events, "$c", "Chứng chỉ"),
        ],
      ),
    );
  }

  Widget _stat(IconData i, String v, String l) {
    return Column(
      children: [
        Icon(i, size: 26),
        const SizedBox(height: 6),
        Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(l, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      t,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    ),
  );

  Widget _tile(IconData i, String t, Color c, VoidCallback tap) {
    return _card(
      child: ListTile(
        onTap: tap,
        leading: CircleAvatar(
          backgroundColor: c.withOpacity(0.15),
          child: Icon(i, color: c),
        ),
        title: Text(t),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _logout() {
    return _card(
      color: Colors.red.withOpacity(0.12),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Đăng xuất",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        onTap: _confirmLogout,
      ),
    );
  }

  Widget _card({required Widget child, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  void _go(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _confirmLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }
}
