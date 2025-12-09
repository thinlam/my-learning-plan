import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slide = Tween<Offset>(
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
  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .snapshots();
  }

  // ================================================================
  // UI BUILD
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
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

          return FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: SlideTransition(
                position: _slide,
                child: _buildBody(name, streak, progress),
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
  AppBar _buildAppBar() {
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
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: CircleAvatar(
            backgroundColor: Colors.teal.shade200,
            child: const Icon(Icons.person, color: Colors.white),
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
  // HERO SECTION
  // ================================================================
  Widget _buildHeroSection(String name, int streak) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.teal.shade300.withOpacity(0.4),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
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
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Streak: $streak ngày",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Icon(Icons.rocket_launch, size: 38, color: Colors.white),
        ],
      ),
    );
  }

  // ================================================================
  // PROGRESS CARD
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
          const SizedBox(height: 18),
          _buildLinearProgress(progress),
          const SizedBox(height: 10),
          Text(
            "Đã hoàn thành ${(progress * 100).toStringAsFixed(0)}%",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinearProgress(double value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          builder: (context, v, child) {
            return Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  height: 12,
                  width: constraints.maxWidth * v,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================================================================
  // QUICK ACTIONS
  // ================================================================
  Widget _buildQuickActions() {
    final items = [
      {'icon': Icons.play_arrow, 'label': "Tiếp tục"},
      {'icon': Icons.list_alt, 'label': "Lộ trình"},
      {'icon': Icons.quiz_rounded, 'label': "Quiz"},
      {'icon': Icons.notifications, 'label': "Nhắc nhở"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e) => _quickAction(e)).toList(),
    );
  }

  Widget _quickAction(Map e) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(e['icon'], color: Colors.teal),
        ),
        const SizedBox(height: 6),
        Text(e['label'], style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  // ================================================================
  // FEATURED TOPICS
  // ================================================================
  Widget _buildFeaturedTopics() {
    final List<Map<String, dynamic>> topics = [
      {"name": "Flutter", "color": Colors.blue},
      {"name": "Frontend", "color": Colors.orange},
      {"name": "AI & Data", "color": Colors.purple},
      {"name": "Thiết kế", "color": Colors.pink},
      {"name": "Kỹ năng mềm", "color": Colors.teal},
      {"name": "Ngôn ngữ", "color": Colors.green},
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
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, i) {
            return Container(
              decoration: _card(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: topics[i]["color"] as Color,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topics[i]["name"] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // QUOTE
  // ================================================================
  Widget _buildQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card().copyWith(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
      ),
      child: Text(
        "“Học mỗi ngày để trở thành phiên bản tốt hơn của chính bạn.”",
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  // ================================================================
  // CARD STYLE
  // ================================================================
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
