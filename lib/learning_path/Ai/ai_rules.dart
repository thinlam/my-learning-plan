import 'ai_learning_path_model.dart';

/// Mô tả profile người học (kết quả khảo sát)
class SurveyProfile {
  final String grade; // "10" | "11" | "12" | "ĐH"
  final List<String> favoriteSubjects;
  final int freeEveningsPerWeek; // số buổi rảnh
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

/// ❤️ Bộ luật AI – Chấm điểm và đề xuất lộ trình
class AiRules {
  /// THƯ VIỆN LỘ TRÌNH MẪU
  static final List<AiLearningPath> baseLibrary = [
    AiLearningPath(
      id: 'basic_10',
      title: 'Lộ trình học đều cho khối 10',
      description:
          'Ôn lại kiến thức nền tảng Toán – Lý – Anh, mỗi ngày 45 phút, phù hợp học sinh khối 10.',
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
          'Ôn tập có chọn lọc, tập trung vào các chương dễ mất gốc cho khối 11.',
      lessonCount: 26,
      difficulty: 'basic',
      targetGrades: ['11'],
      focusSubjects: ['Toán', 'Hóa', 'Anh'],
      recommendedHoursPerWeek: 6,
    ),

    AiLearningPath(
      id: 'grad_12A',
      title: 'Ôn thi tốt nghiệp & Đại học khối A',
      description:
          'Tập trung Toán – Lý – Hóa, kết hợp luyện đề và phân tích dạng bài.',
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
          'Lộ trình tăng cường môn Anh và Văn, dành cho khối 12 thi đại học khối D.',
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
          'Lịch học nhẹ, 30–40 phút/ngày, phù hợp học sinh bận học thêm.',
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
          'Dành cho học sinh muốn cải thiện hoặc nâng cao môn Toán, kèm bài tập tư duy.',
      lessonCount: 22,
      difficulty: 'intermediate',
      targetGrades: ['10', '11', '12'],
      focusSubjects: ['Toán'],
      recommendedHoursPerWeek: 6,
    ),
  ];

  // ⬇⬇⬇ CHẤM ĐIỂM LỘ TRÌNH CHO USER

  static int calculateScore(AiLearningPath path, SurveyProfile profile) {
    int score = 0;

    // 1️⃣ Khớp khối – weight mạnh nhất
    if (path.targetGrades.contains(profile.grade)) {
      score += 30;
    } else if (path.targetGrades.contains('10') ||
        path.targetGrades.contains('11') ||
        path.targetGrades.contains('12')) {
      score += 5;
    }

    // 2️⃣ Khớp môn yêu thích
    for (final s in profile.favoriteSubjects) {
      if (path.focusSubjects.contains(s)) score += 12;
    }

    // 3️⃣ Dựa vào mục tiêu
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

    // 4️⃣ Lịch học rảnh
    if (profile.freeEveningsPerWeek <= 2) {
      // rảnh ít
      if (path.recommendedHoursPerWeek <= 5)
        score += 12;
      else
        score -= 6;
    } else if (profile.freeEveningsPerWeek >= 4) {
      // rảnh nhiều
      if (path.recommendedHoursPerWeek >= 6) score += 8;
    }

    // 5️⃣ Có học thêm?
    if (profile.hasExtraClasses) {
      if (path.recommendedHoursPerWeek <= 7)
        score += 8;
      else
        score -= 6;
    }

    // Điểm tối thiểu 0, tối đa 100+
    if (score < 0) score = 0;

    return score;
  }

  /// 📌 Gán score cho toàn bộ library
  static List<AiLearningPath> applyRules(SurveyProfile profile) {
    return baseLibrary.map((path) {
      final score = calculateScore(path, profile);
      return path.copyWith(score: score);
    }).toList()..sort((a, b) => b.score.compareTo(a.score)); // sort giảm dần
  }
}
