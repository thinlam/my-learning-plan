import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// AI logic
import '../Ai/ai_learning_path_model.dart';
import '../Ai/ai_recommendation_service.dart';
import '../Ai/ai_rules.dart';

// UI
import 'path_detail_page.dart';

class AiPathSuggestionPage extends StatelessWidget {
  /// 🔥 Profile từ khảo sát (bắt buộc)
  final SurveyProfile profile;

  const AiPathSuggestionPage({super.key, required this.profile});

  // ------------------- UI SUPPORT -------------------

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

  // ------------------- MAIN UI -------------------

  @override
  Widget build(BuildContext context) {
    /// 👉 Lấy danh sách lộ trình AI đề xuất
    final List<AiLearningPath> aiSuggestions =
        AiRecommendationService.suggestPaths(profile, limit: 3);

    final int bestScore = aiSuggestions.isEmpty ? 0 : aiSuggestions.first.score;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(
          "Gợi ý lộ trình bằng AI",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          _header(bestScore),
          const SizedBox(height: 18),

          Text(
            "Các lộ trình phù hợp nhất",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          if (aiSuggestions.isEmpty)
            _noSuggestions()
          else
            ...aiSuggestions.map((path) => _buildPathCard(context, path)),
        ],
      ),
    );
  }

  // ------------------- HEADER -------------------

  Widget _header(int bestScore) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.indigo.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 16,
            color: Colors.black26,
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phân tích bởi AI",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  "AI đề xuất lộ trình dựa trên: khối lớp, môn yêu thích, "
                  "thời gian rảnh và mục tiêu học.",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.3,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.insights_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Điểm phù hợp cao nhất: $bestScore%",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- PATH CARD -------------------

  Widget _buildPathCard(BuildContext context, AiLearningPath path) {
    final diffColor = _difficultyColor(path.difficulty);
    final diffLabel = _difficultyLabel(path.difficulty);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.lightBlue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 12,
            color: Colors.black26,
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PathDetailPage(path: path), // ⭐ chuẩn 100%
            ),
          );
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        path.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.3,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _scoreChip(path.score),
                    const SizedBox(height: 6),
                    _difficultyChip(diffLabel, diffColor),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 0.4, color: Colors.white30),
            const SizedBox(height: 8),

            // FOOTER
            Row(
              children: [
                _iconText(
                  Icons.schedule_rounded,
                  '${path.recommendedHoursPerWeek.toStringAsFixed(1)}h/tuần',
                ),

                const SizedBox(width: 12),

                _iconText(
                  Icons.menu_book_rounded,
                  '${path.lessonCount} bài học',
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    'Môn trọng tâm: ${path.focusSubjects.join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.white),
        ),
      ],
    );
  }

  Widget _scoreChip(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 14,
            color: Colors.yellow.shade300,
          ),
          const SizedBox(width: 4),
          Text(
            '$score%',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _difficultyChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  // ------------------- EMPTY VIEW -------------------

  Widget _noSuggestions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Chưa có đủ dữ liệu khảo sát.\n"
              "Hãy hoàn thành khảo sát để AI gợi ý lộ trình phù hợp.",
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
