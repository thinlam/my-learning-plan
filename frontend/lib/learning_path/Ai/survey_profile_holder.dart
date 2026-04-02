import 'ai_rules.dart';

/// 🔹 Lưu trữ tạm thời SurveyProfile sau khi người dùng hoàn thành khảo sát.
/// Điều khiển flow: Survey → AI → Home
class SurveyProfileHolder {
  /// Profile khảo sát
  static SurveyProfile? lastProfile;

  /// 🔥 CỜ ĐÁNH DẤU ĐÃ HOÀN THÀNH KHẢO SÁT
  static bool surveyCompleted = false;

  /// Đã có dữ liệu khảo sát hợp lệ hay chưa
  static bool get hasProfile => lastProfile != null && surveyCompleted;

  /// Reset dữ liệu (logout hoặc làm lại khảo sát)
  static void clear() {
    lastProfile = null;
    surveyCompleted = false;
  }
}
