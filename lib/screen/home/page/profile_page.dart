import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_learning_plan/auth/login_page.dart';

// Pages

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

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ==============================
  // STREAM FIRESTORE USER DATA
  // ==============================
  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .snapshots();
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: StreamBuilder<DocumentSnapshot>(
            stream: userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>?;

              final name = data?["name"] ?? "Không rõ tên";
              final email = data?["email"] ?? user?.email ?? "";
              final lessons = data?["lessons"] ?? 0;
              final hours = data?["hours"] ?? 0;
              final certificates = data?["certificates"] ?? 0;

              return _buildBody(name, email, lessons, hours, certificates);
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      title: Text(
        "Hồ sơ cá nhân",
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.teal.shade800,
        ),
      ),
    );
  }

  Widget _buildBody(
    String name,
    String email,
    int lessons,
    int hours,
    int certificates,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildProfileHeader(name, email),
        const SizedBox(height: 20),
        _buildStats(lessons, hours, certificates),
        const SizedBox(height: 20),
        _buildSectionTitle("Tài khoản"),
        _buildTile(Icons.edit, "Chỉnh sửa hồ sơ", Colors.blue, () {}),
        _buildTile(Icons.lock, "Đổi mật khẩu", Colors.orange, () {}),
        const SizedBox(height: 20),
        _buildSectionTitle("Cài đặt"),
        _buildTile(Icons.notifications, "Thông báo", Colors.green, () {}),
        _buildTile(Icons.language, "Ngôn ngữ", Colors.purple, () {}),
        _buildTile(Icons.settings, "Cài đặt chung", Colors.grey, () {}),
        const SizedBox(height: 20),
        _buildSectionTitle("Khác"),
        _buildTile(Icons.help_center, "Trung tâm hỗ trợ", Colors.indigo, () {}),
        _buildTile(
          Icons.privacy_tip,
          "Điều khoản & Quyền riêng tư",
          Colors.teal,
          () {},
        ),
        const SizedBox(height: 20),
        _buildLogoutButton(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==============================
  // PROFILE HEADER
  // ==============================
  Widget _buildProfileHeader(String name, String email) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _card(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.teal.shade200,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
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
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================
  // STATS BOX
  // ==============================
  Widget _buildStats(int lessons, int hours, int certs) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _card(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(Icons.book, lessons.toString(), "Bài đã học", Colors.blue),
          _statItem(Icons.timer, "${hours}h", "Thời gian", Colors.orange),
          _statItem(
            Icons.emoji_events,
            certs.toString(),
            "Chứng chỉ",
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ==============================
  // SECTION TITLE
  // ==============================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  // ==============================
  // LIST TILE ITEM
  // ==============================
  Widget _buildTile(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _card(),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade500,
        ),
        onTap: onTap,
      ),
    );
  }

  // ==============================
  // LOGOUT BUTTON
  // ==============================
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _confirmLogout,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _card().copyWith(color: Colors.red.shade50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              "Đăng xuất",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Đăng xuất",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Bạn có chắc muốn đăng xuất không?",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context);

              await FirebaseAuth.instance.signOut();

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ==============================
  // CARD STYLE
  // ==============================
  BoxDecoration _card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300.withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
