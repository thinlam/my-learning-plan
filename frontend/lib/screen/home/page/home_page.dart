import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _slide = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
      appBar: _buildAppBar(context),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final name = data?["name"] ?? "Bạn";
          final learningPath = data?["learningPath"];

          return FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: SlideTransition(
                position: _slide,
                child: _buildBody(context, name, learningPath),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(title: const Text("StudyMate"), elevation: 0.4);
  }

  // ================= BODY =================
  Widget _buildBody(
    BuildContext context,
    String name,
    Map<String, dynamic>? learningPath,
  ) {
    final hasPath = learningPath != null;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _hero(context, name),
        const SizedBox(height: 20),

        if (hasPath) _currentPathCard(context, learningPath),

        const SizedBox(height: 24),
        _quickActions(context, hasPath),
        const SizedBox(height: 24),
        _featuredTopics(context),
        const SizedBox(height: 40),
      ],
    );
  }

  // ================= HERO =================
  Widget _hero(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
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

  // ================= CURRENT PATH =================
  Widget _currentPathCard(BuildContext context, Map<String, dynamic> path) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lộ trình hiện tại",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            path["title"] ?? "",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _quickActions(BuildContext context, bool hasPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickItem(context, Icons.play_arrow, "Tiếp tục", enabled: hasPath),
        _quickItem(context, Icons.list_alt, "Lộ trình"),
        _quickItem(context, Icons.quiz, "Quiz"),
        _quickItem(context, Icons.notifications, "Nhắc nhở"),
      ],
    );
  }

  Widget _quickItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool enabled = true,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: enabled
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : Theme.of(context).disabledColor.withOpacity(0.2),
          child: Icon(
            icon,
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).disabledColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  // ================= TOPICS =================
  Widget _featuredTopics(BuildContext context) {
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => t["page"] as Widget),
          ),
          child: _card(
            context,
            child: Center(
              child: Text(
                t["name"] as String,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= CARD =================
  Widget _card(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}
