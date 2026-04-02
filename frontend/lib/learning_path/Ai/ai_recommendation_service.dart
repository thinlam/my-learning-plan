import 'ai_learning_path_model.dart';
import 'ai_rules.dart';

/// 🔥 Service trung gian: nhận profile → trả danh sách lộ trình AI đề xuất
class AiRecommendationService {
  /// ⭐ Đề xuất lộ trình dựa trên profile khảo sát
  static List<AiLearningPath> suggestPaths(
    SurveyProfile profile, {
    int limit = 3,
  }) {
    // Gọi rule engine để chấm điểm + sắp xếp
    final scoredList = AiRules.applyRules(profile);

    // Trả về tối đa "limit" lộ trình
    return scoredList.take(limit).toList();
  }

  /// ⭐ Trả về lộ trình mặc định (khi user chưa khảo sát)
  static List<AiLearningPath> suggestDefault({int limit = 3}) {
    // Tạo bản sao để tránh ghi đè vào thư viện gốc
    final cloned = AiRules.baseLibrary.map((p) => p.copyWith()).toList();

    return cloned.take(limit).toList();
  }
}
