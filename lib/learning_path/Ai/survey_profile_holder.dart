import 'ai_rules.dart';

/// 🔹 Lưu trữ tạm thời SurveyProfile sau khi người dùng hoàn thành khảo sát.
/// Các trang như PathSelectionPage hoặc AiPathSuggestionPage sẽ lấy profile từ đây.
///
/// Khi user làm xong khảo sát:
///   SurveyProfileHolder.lastProfile = SurveyProfile(...);
///
/// Khi AI cần dữ liệu khảo sát:
///   final profile = SurveyProfileHolder.lastProfile;
class SurveyProfileHolder {
  static SurveyProfile? lastProfile;
}
