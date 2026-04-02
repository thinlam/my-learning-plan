import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_learning_plan/learning_path/Ai/ai_rules.dart';

// Import UI
import '../widgets/suggestion_card.dart';
import 'path_detail_page.dart';
import 'ai_path_suggestion_page.dart';

// Import AI Models
import '../Ai/ai_learning_path_model.dart';
import '../Ai/survey_profile_holder.dart';

class PathSelectionPage extends StatelessWidget {
  const PathSelectionPage({super.key});

  // ⭐ Danh sách Lộ trình DEMO (Nhưng dùng AiLearningPath để đồng bộ luôn)
  List<AiLearningPath> get _demoPaths => [
    AiLearningPath(
      id: "p1",
      title: "Lộ trình Flutter cho người mới",
      description: "Bắt đầu từ con số 0, phù hợp học sinh THPT.",
      lessonCount: 24,
      difficulty: "basic",
      targetGrades: ["10", "11", "12"],
      focusSubjects: ["Tin học"],
      recommendedHoursPerWeek: 4,
    ),
    AiLearningPath(
      id: "p2",
      title: "Lộ trình Lập trình Mobile nâng cao",
      description:
          "Tập trung vào state management, kiến trúc và tối ưu hiệu năng.",
      lessonCount: 30,
      difficulty: "advanced",
      targetGrades: ["12", "ĐH"],
      focusSubjects: ["Tin học"],
      recommendedHoursPerWeek: 6,
    ),
    AiLearningPath(
      id: "p3",
      title: "Ôn thi Đại học khối A – Lập trình",
      description:
          "Kết hợp ôn Toán + tư duy thuật toán + luyện đề lập trình cơ bản.",
      lessonCount: 18,
      difficulty: "intermediate",
      targetGrades: ["12"],
      focusSubjects: ["Toán", "Tin học"],
      recommendedHoursPerWeek: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'Lộ trình học',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: const [Icon(Icons.help_outline_rounded, size: 22)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.blue.withOpacity(0.07),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.blue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chọn lộ trình phù hợp hoặc để AI gợi ý cho bạn.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.3,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 🔹 Suggestion Card
              Text(
                'Trợ lý AI',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 6),

              SuggestionCard(
                onTap: () {
                  final profile =
                      SurveyProfileHolder.lastProfile ??
                      const SurveyProfile(
                        grade: '12',
                        favoriteSubjects: ['Toán'],
                        freeEveningsPerWeek: 3,
                        hasExtraClasses: false,
                        goal: 'trung bình',
                      );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiPathSuggestionPage(profile: profile),
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // Title + số lượng
              Row(
                children: [
                  Text(
                    'Các lộ trình nổi bật',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${_demoPaths.length} lộ trình',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Mỗi lộ trình được thiết kế rõ ràng để dễ theo dõi.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),

              // ⭐ List of demo AI Learning Paths
              Expanded(
                child: ListView.separated(
                  itemCount: _demoPaths.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final path = _demoPaths[index];

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          path.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          path.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PathDetailPage(path: path),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
