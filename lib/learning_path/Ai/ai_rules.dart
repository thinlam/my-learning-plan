import 'ai_learning_path_model.dart';

/// ===============================
/// 👤 SURVEY PROFILE (DATA)
/// ===============================
/// Hồ sơ người học – kết quả khảo sát
class SurveyProfile {
  final String grade; // "10" | "11" | "12" | "ĐH"
  final List<String> favoriteSubjects;
  final int freeEveningsPerWeek; // số buổi rảnh / tuần
  final bool hasExtraClasses; // có học thêm không
  final String goal; // "trung bình" | "khá" | "giỏi" | "thi ĐH" | "thi chuyên"

  const SurveyProfile({
    required this.grade,
    required this.favoriteSubjects,
    required this.freeEveningsPerWeek,
    required this.hasExtraClasses,
    required this.goal,
  });
}

/// ===============================
/// ❤️ AI RULES – GỢI Ý LỘ TRÌNH
/// ===============================
class AiRules {
  /// 📚 THƯ VIỆN LỘ TRÌNH MẪU
  static final List<AiLearningPath> baseLibrary = [
    AiLearningPath(
      id: 'basic_10',
      title: 'Lộ trình học đều cho khối 10',
      description:
          'Ôn Toán – Lý – Anh, mỗi ngày ~45 phút, phù hợp học sinh khối 10.',
      lessonCount: 24,
      difficulty: 'basic',
      targetGrades: ['10'],
      focusSubjects: ['Toán', 'Lý', 'Anh'],
      recommendedHoursPerWeek: 5,
    ),
    AiLearningPath(
      id: 'basic_11',
      title: 'Củng cố kiến thức khối 11',
      description:
          'Ôn tập có chọn lọc các chương dễ mất gốc cho khối 11.',
      lessonCount: 26,
      difficulty: 'basic',
      targetGrades: ['11'],
      focusSubjects: ['Toán', 'Hóa', 'Anh'],
      recommendedHoursPerWeek: 6,
    ),
    AiLearningPath(
      id: 'grad_12A',
      title: 'Ôn thi tốt nghiệp & ĐH khối A',
      description:
          'Toán – Lý – Hóa, kết hợp luyện đề và phân tích dạng bài.',
      lessonCount: 32,
      difficulty: 'advanced',
      targetGrades: ['12'],
      focusSubjects: ['Toán', 'Lý', 'Hóa'],
      recommendedHoursPerWeek: 10,
    ),
    AiLearningPath(
      id: 'grad_12D',
      title: 'Ôn thi Đại học khối D',
      description:
          'Tăng cường Văn – Anh, dành cho khối 12 thi đại học khối D.',
      lessonCount: 30,
      difficulty: 'advanced',
      targetGrades: ['12'],
      focusSubjects: ['Văn', 'Anh', 'Toán'],
      recommendedHoursPerWeek: 9,
    ),
    AiLearningPath(
      id: 'daily_focus',
      title: 'Học nhẹ nhưng đều mỗi ngày',
      description:
          '30–40 phút/ngày, phù hợp học sinh bận học thêm.',
      lessonCount: 28,
      difficulty: 'intermediate',
      targetGrades: ['10', '11', '12'],
      focusSubjects: ['Toán', 'Anh'],
      recommendedHoursPerWeek: 4,
    ),
    AiLearningPath(
      id: 'strong_math',
      title: 'Tăng cường Toán & Tư duy logic',
      description:
          'Dành cho học sinh muốn cải thiện hoặc nâng cao môn Toán.',
      lessonCount: 22,
      difficulty: 'intermediate',
      targetGrades: ['10', '11', '12'],
      focusSubjects: ['Toán'],
      recommendedHoursPerWeek: 6,
    ),
  ];

  /// ===============================
  /// 🧠 TÍNH ĐIỂM 1 LỘ TRÌNH
  /// ===============================
  static int calculateScore(AiLearningPath path, SurveyProfile profile) {
    int score = 0;

    // 1️⃣ Khớp khối (quan trọng nhất)
    if (path.targetGrades.contains(profile.grade)) {
      score += 30;
    } else {
      score += 5;
    }

    // 2️⃣ Khớp môn yêu thích
    for (final subject in profile.favoriteSubjects) {
      if (path.focusSubjects.contains(subject)) {
        score += 12;
      }
    }

    // 3️⃣ Mục tiêu học
    switch (profile.goal.toLowerCase()) {
      case 'thi đh':
      case 'thi đại học':
        if (path.difficulty == 'advanced') score += 25;
        break;

      case 'thi chuyên':
        if (path.difficulty == 'advanced' &&
            path.focusSubjects.contains('Toán')) {
          score += 25;
        }
        break;

      case 'giỏi':
        if (path.difficulty != 'basic') score += 18;
        break;

      case 'khá':
        if (path.difficulty == 'intermediate') score += 15;
        break;

      case 'trung bình':
      default:
        if (path.difficulty == 'basic') score += 15;
        break;
    }

    // 4️⃣ Thời gian rảnh
    if (profile.freeEveningsPerWeek <= 2) {
      if (path.recommendedHoursPerWeek <= 5) {
        score += 12;
      } else {
        score -= 6;
      }
    } else if (profile.freeEveningsPerWeek >= 4) {
      if (path.recommendedHoursPerWeek >= 6) score += 8;
    }

    // 5️⃣ Có học thêm
    if (profile.hasExtraClasses && path.recommendedHoursPerWeek > 7) {
      score -= 6;
    }

    return score < 0 ? 0 : score;
  }

  /// ===============================
  /// ⭐ GỢI Ý LỘ TRÌNH (SORT DESC)
  /// ===============================
  static List<AiLearningPath> applyRules(SurveyProfile profile) {
    return baseLibrary
        .map((path) =>
            path.copyWith(score: calculateScore(path, profile)))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }
}
