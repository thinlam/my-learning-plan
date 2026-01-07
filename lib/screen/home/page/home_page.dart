import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Pages
import 'navigation_page.dart';

// Topic pages
import 'package:my_learning_plan/screen/topics/language/language_page.dart';
import 'package:my_learning_plan/screen/topics/ai_data/ai_data_page.dart';
import 'package:my_learning_plan/screen/topics/design/design_page.dart';
import 'package:my_learning_plan/screen/topics/flutter/flutter_page.dart';
import 'package:my_learning_plan/screen/topics/frontend/frontend_page.dart';
import 'package:my_learning_plan/screen/topics/soft_skills/soft_skills_page.dart';

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

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween(begin: 0.94, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _slide = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<DocumentSnapshot> get userStream =>
      FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots();

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
          final learningPath = data?["learningPath"];

          return Scaffold(
            appBar: _buildAppBar(),
            body: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: SlideTransition(
                  position: _slide,
                  child: _buildBody(name, learningPath, data),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ======================================================
  // APP BAR
  // ======================================================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      title: Text(
        "StudyMate",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: Colors.teal.shade800,
        ),
      ),
      centerTitle: false,
    );
  }

  // ======================================================
  // BODY
  // ======================================================
  Widget _buildBody(
    String name,
    Map<String, dynamic>? learningPath,
    Map<String, dynamic>? data,
  ) {
    final hasPath = learningPath != null;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _hero(name),
        const SizedBox(height: 20),

        if (hasPath) _currentPathCard(learningPath),

        const SizedBox(height: 24),
        _quickActions(hasPath),
        const SizedBox(height: 24),
        _featuredTopics(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ======================================================
  // HERO
  // ======================================================
  Widget _hero(String name) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        "Xin chào $name 👋\nHôm nay bạn muốn học gì?",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ======================================================
  // CURRENT LEARNING PATH
  // ======================================================
  Widget _currentPathCard(Map<String, dynamic> path) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lộ trình hiện tại",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            path["title"] ?? "",
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // QUICK ACTIONS
  // ======================================================
  Widget _quickActions(bool hasPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickItem(
          icon: Icons.play_arrow,
          label: "Tiếp tục",
          enabled: hasPath,
        ),
        _quickItem(
          icon: Icons.list_alt,
          label: "Lộ trình",
          enabled: true,
        ),
        _quickItem(icon: Icons.quiz, label: "Quiz"),
        _quickItem(icon: Icons.notifications, label: "Nhắc nhở"),
      ],
    );
  }

  Widget _quickItem({
    required IconData icon,
    required String label,
    bool enabled = false,
  }) {
    return InkWell(
      onTap: enabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NavigationPage(initialIndex: 1),
                ),
              );
            }
          : null,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                enabled ? Colors.teal.shade50 : Colors.grey.shade200,
            child: Icon(
              icon,
              color: enabled ? Colors.teal : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }

  // ======================================================
  // TOPICS
  // ======================================================
  Widget _featuredTopics() {
    final topics = [
      {"name": "Flutter", "page": const FlutterPage()},
      {"name": "Frontend", "page": const FrontendPage()},
      {"name": "AI & Data", "page": const AiDataPage()},
      {"name": "Thiết kế", "page": const DesignPage()},
      {"name": "Kỹ năng mềm", "page": const SoftSkillsPage()},
      {"name": "Ngôn ngữ", "page": const LanguagePage()},
    ];

    return GridView.builder(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => t["page"] as Widget),
            );
          },
          child: Container(
            decoration: _card(),
            child: Center(
              child: Text(
                t["name"] as String,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // CARD STYLE
  // ======================================================
  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
