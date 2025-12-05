import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ⭐ IMPORT AI + SURVEY
import '../../learning_path/Ai/ai_rules.dart';
import '../../learning_path/Ai/ai_learning_path_model.dart';
import '../../learning_path/Ai/ai_recommendation_service.dart';
import '../../learning_path/Ai/survey_profile_holder.dart';

// ⭐ IMPORT WIDGET
import 'weekly_chart.dart';
import 'subject_progress.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ 1. Lấy profile đã lưu từ Survey
    final SurveyProfile profile =
        SurveyProfileHolder.lastProfile ??
        SurveyProfile(
          grade: "12",
          favoriteSubjects: ["Toán"],
          freeEveningsPerWeek: 3,
          hasExtraClasses: false,
          goal: "trung bình",
        );

    // ⭐ 2. Lấy lộ trình đề xuất tốt nhất dựa trên profile
    final List<AiLearningPath> aiPaths = AiRecommendationService.suggestPaths(
      profile,
      limit: 1,
    );

    final AiLearningPath? bestPath = aiPaths.isNotEmpty ? aiPaths.first : null;

    // ⭐ 3. Tiến độ tính dựa trên bài học
    final int completedLessons = bestPath?.completedLessons ?? 0;
    final int totalLessons = bestPath?.lessonCount ?? 1;

    final double percent = completedLessons / totalLessons;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
        title: Text(
          "Tiến độ học tập",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tổng tiến độ ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: _box(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng quan tiến độ",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // % hoàn thành
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: CircularProgressIndicator(
                              value: percent,
                              strokeWidth: 10,
                              color: Colors.teal,
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                          Text(
                            "${(percent * 100).toInt()}%",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          bestPath == null
                              ? "Chưa có dữ liệu tiến độ. Hãy hoàn thành khảo sát và nhận lộ trình!"
                              : "Bạn đã hoàn thành ${(percent * 100).toInt()}% lộ trình “${bestPath.title}”. Tiếp tục cố gắng nhé!",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Biểu đồ học tập theo tuần ---
            Text(
              "Biểu đồ học tập theo tuần",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const WeeklyChart(),

            const SizedBox(height: 20),

            // --- Môn mạnh / yếu ---
            Text(
              "Môn học mạnh – yếu",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const SubjectProgress(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(offset: Offset(0, 3), blurRadius: 8, color: Colors.black12),
      ],
    );
  }
}
