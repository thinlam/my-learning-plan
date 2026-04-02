/// Model đại diện cho 1 lộ trình học được AI đề xuất.
class AiLearningPath {
  /// ID nội bộ (không bắt buộc hiển thị)
  final String id;

  /// Tên lộ trình (ví dụ: "Lộ trình ôn thi khối 12")
  final String title;

  /// Mô tả ngắn gọn lộ trình
  final String description;

  /// Tổng số bài học
  final int lessonCount;

  /// Độ khó: "basic", "intermediate", "advanced"
  final String difficulty;

  /// Khối lớp phù hợp: ["10"], ["11"], ["12"], hoặc ["10","11","12"]
  final List<String> targetGrades;

  /// Các môn trọng tâm
  final List<String> focusSubjects;

  /// Số giờ học/tuần được đề xuất
  final double recommendedHoursPerWeek;

  /// Điểm phù hợp AI tính (0 → 100)
  final int score;

  /// ⭐ Số bài học user đã hoàn thành
  int completedLessons;

  AiLearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonCount,
    required this.difficulty,
    required this.targetGrades,
    required this.focusSubjects,
    required this.recommendedHoursPerWeek,
    this.score = 0,
    this.completedLessons = 0, // ⭐ mặc định chưa học bài nào
  });

  /// ⭐ Copy lại object với score hoặc tiến độ cập nhật
  AiLearningPath copyWith({int? score, int? completedLessons}) {
    return AiLearningPath(
      id: id,
      title: title,
      description: description,
      lessonCount: lessonCount,
      difficulty: difficulty,
      targetGrades: targetGrades,
      focusSubjects: focusSubjects,
      recommendedHoursPerWeek: recommendedHoursPerWeek,
      score: score ?? this.score,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }

  /// ⭐ Tính % hoàn thành dựa vào số bài học user đã làm
  double get progressPercent {
    if (lessonCount == 0) return 0;
    return completedLessons / lessonCount;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lessonCount': lessonCount,
      'difficulty': difficulty,
      'targetGrades': targetGrades,
      'focusSubjects': focusSubjects,
      'recommendedHoursPerWeek': recommendedHoursPerWeek,
      'score': score,
      'completedLessons': completedLessons, // ⭐ lưu tiến độ
    };
  }
}
