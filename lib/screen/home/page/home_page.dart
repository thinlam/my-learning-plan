import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_learning_plan/screen/topics/language/language_page.dart';
import 'package:my_learning_plan/screen/topics/ai_data/ai_data_page.dart';
import 'package:my_learning_plan/screen/topics/design/design_page.dart';
import 'package:my_learning_plan/screen/topics/flutter/flutter_page.dart';
import 'package:my_learning_plan/screen/topics/frontend/frontend_page.dart';
import 'package:my_learning_plan/screen/topics/soft_skills/soft_skills_page.dart';

// Topic pages

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scale = Tween(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slide = Tween(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================================================================
  // STREAM USER DATA
  // ================================================================
  Stream<DocumentSnapshot> get userStream =>
      FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots();

  // ================================================================
  // UI BUILD
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          final name = data?["name"] ?? "Bạn";
          final streak = data?["streak"] ?? 0;
          final progress = (data?["progress"] ?? 0.0).toDouble();
          final avatarUrl = data?["avatarUrl"] as String?;

          return Scaffold(
            appBar: _buildAppBar(avatarUrl),
            body: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: SlideTransition(
                  position: _slide,
                  child: _buildBody(name, streak, progress),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================
  AppBar _buildAppBar(String? avatarUrl) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.7,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: Colors.teal),
          ),
          const SizedBox(width: 10),
          Text(
            "StudyMate",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.teal.shade800,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          color: Colors.teal.shade700,
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.teal.shade200,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // MAIN BODY
  // ================================================================
  Widget _buildBody(String name, int streak, double progress) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeroSection(name, streak),
        const SizedBox(height: 24),
        _buildProgressCard(progress),
        const SizedBox(height: 24),
        _buildQuickActions(),
        const SizedBox(height: 24),
        _buildFeaturedTopics(),
        const SizedBox(height: 24),
        _buildQuote(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ================================================================
  // HERO
  // ================================================================
  Widget _buildHeroSection(String name, int streak) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Xin chào $name 👋",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Hôm nay bạn muốn học gì?",
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          Text(
            "🔥 Streak: $streak ngày",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PROGRESS
  // ================================================================
  Widget _buildProgressCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tiến độ học tập",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            color: Colors.teal,
          ),
          const SizedBox(height: 8),
          Text("Hoàn thành ${(progress * 100).toInt()}%"),
        ],
      ),
    );
  }

  // ================================================================
  // QUICK ACTIONS
  // ================================================================
  Widget _buildQuickActions() {
    final items = [
      {"icon": Icons.play_arrow, "label": "Tiếp tục"},
      {"icon": Icons.list_alt, "label": "Lộ trình"},
      {"icon": Icons.quiz, "label": "Quiz"},
      {"icon": Icons.notifications, "label": "Nhắc nhở"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e) {
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: Icon(e["icon"] as IconData, color: Colors.teal),
            ),
            const SizedBox(height: 6),
            Text(
              e["label"] as String,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ================================================================
  // FEATURED TOPICS (CLICKABLE)
  // ================================================================
  Widget _buildFeaturedTopics() {
    final topics = [
      {"name": "Flutter", "icon": Icons.flutter_dash, "color": Colors.blue},
      {"name": "Frontend", "icon": Icons.web, "color": Colors.orange},
      {"name": "AI & Data", "icon": Icons.auto_graph, "color": Colors.purple},
      {"name": "Thiết kế", "icon": Icons.palette, "color": Colors.pink},
      {"name": "Kỹ năng mềm", "icon": Icons.psychology, "color": Colors.teal},
      {"name": "Ngôn ngữ", "icon": Icons.language, "color": Colors.green},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chủ đề nổi bật",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, i) {
            final t = topics[i];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openTopic(context, t["name"] as String),
              child: Container(
                decoration: _card(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t["icon"] as IconData,
                      color: t["color"] as Color,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t["name"] as String,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // NAVIGATION
  // ================================================================
  void _openTopic(BuildContext context, String name) {
    final map = {
      "Flutter": const FlutterPage(),
      "Frontend": const FrontendPage(),
      "AI & Data": const AiDataPage(),
      "Thiết kế": const DesignPage(),
      "Kỹ năng mềm": const SoftSkillsPage(),
      "Ngôn ngữ": const LanguagePage(),
    };

    Navigator.push(context, MaterialPageRoute(builder: (_) => map[name]!));
  }

  // ================================================================
  // QUOTE
  // ================================================================
  Widget _buildQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Text(
        "“Học mỗi ngày để trở thành phiên bản tốt hơn của chính bạn.”",
        style: GoogleFonts.poppins(fontStyle: FontStyle.italic),
      ),
    );
  }

  // ================================================================
  // CARD STYLE
  // ================================================================
  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300.withOpacity(0.5),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
