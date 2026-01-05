import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// AI
import '../Ai/ai_rules.dart';
import '../Ai/survey_profile_holder.dart';

// AI PAGE
import 'ai_path_suggestion_page.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // ===== CÂU CŨ =====
  String? selectedGrade;
  String? selectedPlayTime;
  List<String> selectedSubjects = [];

  // ===== CÂU MỚI =====
  String? selectedExtraClass;
  List<String> selectedStudyTimes = [];
  List<String> selectedExtraSubjects = [];
  List<String> selectedExtraDays = [];

  // ===== DATA =====
  final List<String> grades = ["Lớp 10", "Lớp 11", "Lớp 12", "Đại học"];

  final List<String> playTimes = [
    "1-2 tiếng/ngày",
    "3-4 tiếng/ngày",
    "5 tiếng trở lên",
  ];

  final List<String> subjects = [
    "Toán",
    "Lý",
    "Hóa",
    "Văn",
    "Anh",
    "Sinh",
    "Sử",
    "Địa",
    "Tin học",
  ];

  final List<String> extraClassOptions = [
    "Có học thêm",
    "Không học thêm",
  ];

  final List<String> studyTimes = [
    "Buổi sáng",
    "Buổi chiều",
    "Buổi tối",
  ];

  final List<String> extraDays = [
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
    "Chủ nhật",
  ];

  // ============================
  // SUBMIT SURVEY (GIỮ NGUYÊN)
  // ============================
  Future<void> _finishSurvey() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final profile = SurveyProfile(
        grade: _mapGradeToCode(selectedGrade),
        favoriteSubjects: selectedSubjects,
        freeEveningsPerWeek: 3,
        hasExtraClasses: selectedExtraClass == "Có học thêm",
        goal: _mapPlayTimeToGoal(selectedPlayTime),
      );

      SurveyProfileHolder.lastProfile = profile;

      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "surveyCompleted": true,
        "surveyData": {
          "grade": profile.grade,
          "favoriteSubjects": profile.favoriteSubjects,
          "freeEveningsPerWeek": profile.freeEveningsPerWeek,
          "hasExtraClasses": profile.hasExtraClasses,
          "goal": profile.goal,
          "studyTimes": selectedStudyTimes,
          "extraSubjects": selectedExtraSubjects,
          "extraDays": selectedExtraDays,
          "updatedAt": FieldValue.serverTimestamp(),
        },
      });

      _goToAiPage();
    } catch (e) {
      debugPrint("🔥 Survey error: $e");
    }
  }

  void _goToAiPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AiPathSuggestionPage(profile: SurveyProfileHolder.lastProfile!),
      ),
    );
  }

  // ============================
  // MAP
  // ============================
  String _mapGradeToCode(String? grade) {
    switch (grade) {
      case "Lớp 10":
        return "10";
      case "Lớp 11":
        return "11";
      case "Lớp 12":
        return "12";
      case "Đại học":
        return "ĐH";
    }
    return "12";
  }

  String _mapPlayTimeToGoal(String? playTime) {
    switch (playTime) {
      case "1-2 tiếng/ngày":
        return "trung bình";
      case "3-4 tiếng/ngày":
        return "khá";
      case "5 tiếng trở lên":
        return "giỏi";
    }
    return "trung bình";
  }

  bool get _isSurveyDone =>
      selectedGrade != null &&
      selectedPlayTime != null &&
      selectedSubjects.isNotEmpty &&
      selectedExtraClass != null;

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khảo sát đầu vào"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _title("1. Bạn đang học khối nào?"),
          _radioList(grades, selectedGrade,
              (v) => setState(() => selectedGrade = v)),

          _title("2. Thời gian học mỗi ngày?"),
          _radioList(playTimes, selectedPlayTime,
              (v) => setState(() => selectedPlayTime = v)),

          _title("3. Môn học yêu thích (chọn ít nhất 1)"),
          Wrap(spacing: 10, children: subjects.map(_subjectChip).toList()),

          _title("4. Bạn có học thêm không?"),
          _radioList(extraClassOptions, selectedExtraClass,
              (v) => setState(() => selectedExtraClass = v)),

          _title("5. Bạn thường học vào thời điểm nào?"),
          Wrap(
            spacing: 10,
            children: studyTimes.map(_multiChip(selectedStudyTimes)).toList(),
          ),

          _title("6. Nếu học thêm, bạn học môn nào?"),
          Wrap(
            spacing: 10,
            children:
                subjects.map(_multiChip(selectedExtraSubjects)).toList(),
          ),

          _title("7. Bạn học thêm vào ngày nào?"),
          Wrap(
            spacing: 10,
            children: extraDays.map(_multiChip(selectedExtraDays)).toList(),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSurveyDone ? _finishSurvey : null,
              child: const Text("Hoàn thành khảo sát"),
            ),
          ),
        ]),
      ),
    );
  }

  // ============================
  // WIDGETS
  // ============================
  Widget _title(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      );

  Widget _radioList(
    List<String> items,
    String? value,
    Function(String) onTap,
  ) {
    return Column(
      children: items
          .map((e) => ListTile(
                title: Text(e),
                trailing: value == e
                    ? const Icon(Icons.check_circle, color: Colors.teal)
                    : null,
                onTap: () => onTap(e),
              ))
          .toList(),
    );
  }

  Widget _subjectChip(String s) => ChoiceChip(
        label: Text(s),
        selected: selectedSubjects.contains(s),
        onSelected: (_) => setState(() {
          selectedSubjects.contains(s)
              ? selectedSubjects.remove(s)
              : selectedSubjects.add(s);
        }),
      );

  ChoiceChip Function(String) _multiChip(List<String> list) {
    return (s) => ChoiceChip(
          label: Text(s),
          selected: list.contains(s),
          onSelected: (_) => setState(() {
            list.contains(s) ? list.remove(s) : list.add(s);
          }),
        );
  }
}
