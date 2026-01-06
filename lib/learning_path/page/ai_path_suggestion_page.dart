import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// AI
import '../Ai/ai_learning_path_model.dart';
import '../Ai/ai_recommendation_service.dart';
import '../Ai/ai_rules.dart';

// UI
import 'path_detail_page.dart';
import '../../screen/home/page/navigation_page.dart';

class AiPathSuggestionPage extends StatelessWidget {
  final SurveyProfile profile;

  const AiPathSuggestionPage({super.key, required this.profile});

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'basic':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  String _difficultyLabel(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'basic':
        return 'Cơ bản';
      case 'intermediate':
        return 'Trung bình';
      case 'advanced':
        return 'Nâng cao';
      default:
        return difficulty;
    }
  }

  // ================= APPLY PATH (FINAL – CHẮC CHẮN NHẢY TAB) =================
  Future<void> _applyPath(BuildContext context, AiLearningPath path) async {
    debugPrint("▶️ APPLY PATH CLICKED");

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bạn chưa đăng nhập")),
        );
        return;
      }

      final uid = user.uid;
      debugPrint("✅ UID = $uid");

      // 🔥 GHI AN TOÀN: TẠO DOC NẾU CHƯA CÓ
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set({
        "learningPath": {
          "title": path.title,
          "description": path.description,
          "difficulty": path.difficulty,
          "score": path.score,
          "recommendedHoursPerWeek": path.recommendedHoursPerWeek,
          "lessonCount": path.lessonCount,
          "focusSubjects": path.focusSubjects,
          "appliedAt": FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));

      debugPrint("✅ FIRESTORE WRITE SUCCESS");

      // 🔥 NHẢY TAB LỘ TRÌNH
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const NavigationPage(initialIndex: 1),
        ),
        (_) => false,
      );
    } catch (e, s) {
      debugPrint("❌ APPLY PATH ERROR: $e");
      debugPrintStack(stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiSuggestions =
        AiRecommendationService.suggestPaths(profile, limit: 3);

    final bestScore =
        aiSuggestions.isEmpty ? 0 : aiSuggestions.first.score;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "AI gợi ý lộ trình",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const NavigationPage(initialIndex: 0),
              ),
              (_) => false,
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _header(bestScore),
          const SizedBox(height: 20),
          ...aiSuggestions.map(
            (path) => _buildPathCard(context, path),
          ),
        ],
      ),
    );
  }

  Widget _header(int bestScore) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.indigo],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Điểm phù hợp cao nhất: $bestScore%",
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

 Widget _buildPathCard(BuildContext context, AiLearningPath path) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // ⭐ FIX CHÍNH
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            path.title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            path.description,
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PathDetailPage(path: path),
              ),
            );
          },
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scoreChip(path.score),
              const SizedBox(height: 6),
              _difficultyChip(
                _difficultyLabel(path.difficulty),
                _difficultyColor(path.difficulty),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _applyPath(context, path),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44), // ổn định chiều cao
            ),
            child: const Text("Áp dụng lộ trình"),
          ),
        ),
      ],
    ),
  );
}


  Widget _scoreChip(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$score%",
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _difficultyChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}
