import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Pages
import '../../screen/home/page/navigation_page.dart';

// AI
import '../../learning_path/Ai/ai_rules.dart';
import '../../learning_path/Ai/survey_profile_holder.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // CÂU 1 + 2 + 4 — dạng chọn 1
  String? selectedGrade;
  String? selectedPlayTime;
  String? selectedExtraClass;

  // CÂU 3 — chọn nhiều
  List<String> selectedSubjects = [];

  // CÂU 5 — chọn nhiều
  List<String> selectedStudyTimes = [];

  // CÂU 6 - Môn học học thêm
  List<String> selectedExtraSubjects = [];

  // CÂU 7 - Ngày học thêm
  List<String> selectedExtraDays = [];

  // CÂU 8 - Giờ học thêm
  TimeOfDay? extraClassTime;

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

  final List<String> extraClass = ["Có học thêm", "Không học thêm"];
  final List<String> studyTimes = [
    "Buổi sáng",
    "Buổi chiều",
    "Buổi tối",
    "Cuối Tuần",
  ];

  final List<String> extraSubjects = [
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
  // HOÀN THÀNH KHẢO SÁT
  // ============================
  Future<void> _finishSurvey() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Khối lớp → code
      final gradeCode = _mapGradeToCode(selectedGrade);

      // Môn yêu thích
      final favoriteSubjects = List<String>.from(selectedSubjects);

      // Số buổi rảnh trong tuần
      final busyDays = selectedExtraDays.length;
      int freeEveningsPerWeek = 7 - busyDays;
      if (freeEveningsPerWeek < 1) freeEveningsPerWeek = 1;

      final hasExtraClasses = selectedExtraClass == "Có học thêm";

      // Mục tiêu
      final goal = _mapPlayTimeToGoal(selectedPlayTime);

      // Lưu vào AI local
      SurveyProfileHolder.lastProfile = SurveyProfile(
        grade: gradeCode,
        favoriteSubjects: favoriteSubjects,
        freeEveningsPerWeek: freeEveningsPerWeek,
        hasExtraClasses: hasExtraClasses,
        goal: goal,
      );

      // LƯU FIRESTORE
      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "surveyCompleted": true,
        "surveyData": {
          "grade": gradeCode,
          "favoriteSubjects": favoriteSubjects,
          "freeEveningsPerWeek": freeEveningsPerWeek,
          "hasExtraClasses": hasExtraClasses,
          "goal": goal,
          "extraSubjects": selectedExtraSubjects,
          "extraDays": selectedExtraDays,
          "extraClassTime": extraClassTime?.format(context),
          "updatedAt": FieldValue.serverTimestamp(),
        },
      });

      _showSuccessDialog();
    } catch (e) {
      print("🔥 Lỗi lưu khảo sát: $e");
    }
  }

  // ============================
  // MAP HỖ TRỢ
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
        return "giỏi";
      case "3-4 tiếng/ngày":
        return "khá";
      case "5 tiếng trở lên":
        return "trung bình";
    }
    return "trung bình";
  }

  // ============================
  // POPUP + CHUYỂN VỀ HOME
  // ============================
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 70, color: Colors.teal),
                const SizedBox(height: 16),
                Text(
                  "Khảo sát thành công!",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Chúng tôi đang tạo lộ trình học phù hợp nhất!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationPage()),
      );
    });
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Khảo sát đầu vào",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("1. Bạn đang học khối nào?"),
            _buildToggleRadio(
              grades,
              selectedGrade,
              (v) => setState(() => selectedGrade = v),
            ),

            _title("2. Thời gian giải trí mỗi ngày?"),
            _buildToggleRadio(
              playTimes,
              selectedPlayTime,
              (v) => setState(() => selectedPlayTime = v),
            ),

            _title("3. Môn học yêu thích? (Nhiều lựa chọn)"),
            Wrap(
              spacing: 10,
              children: subjects
                  .map(
                    (s) => ChoiceChip(
                      label: Text(s),
                      selected: selectedSubjects.contains(s),
                      selectedColor: Colors.teal,
                      labelStyle: TextStyle(
                        color: selectedSubjects.contains(s)
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedSubjects.contains(s)
                              ? selectedSubjects.remove(s)
                              : selectedSubjects.add(s);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            _title("4. Bạn có đi học thêm?"),
            _buildToggleRadio(
              extraClass,
              selectedExtraClass,
              (v) => setState(() => selectedExtraClass = v),
            ),

            _title("5. Bạn thường ôn bài vào thời điểm nào? (Nhiều lựa chọn)"),
            Column(
              children: studyTimes.map((item) {
                final selected = selectedStudyTimes.contains(item);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected
                          ? selectedStudyTimes.remove(item)
                          : selectedStudyTimes.add(item);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.teal.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? Colors.teal : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                        Icon(
                          selected ? Icons.check_circle : Icons.circle_outlined,
                          color: selected ? Colors.teal : Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _title("6. Bạn học thêm môn gì? (Nhiều lựa chọn)"),
            Wrap(
              spacing: 10,
              children: extraSubjects
                  .map(
                    (s) => ChoiceChip(
                      label: Text(s),
                      selected: selectedExtraSubjects.contains(s),
                      selectedColor: Colors.teal,
                      labelStyle: TextStyle(
                        color: selectedExtraSubjects.contains(s)
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedExtraSubjects.contains(s)
                              ? selectedExtraSubjects.remove(s)
                              : selectedExtraSubjects.add(s);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            _title("7. Bạn học thêm vào ngày nào?"),
            Wrap(
              spacing: 10,
              children: extraDays
                  .map(
                    (d) => ChoiceChip(
                      label: Text(d),
                      selected: selectedExtraDays.contains(d),
                      selectedColor: Colors.teal,
                      labelStyle: TextStyle(
                        color: selectedExtraDays.contains(d)
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedExtraDays.contains(d)
                              ? selectedExtraDays.remove(d)
                              : selectedExtraDays.add(d);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            _title("8. Bạn học thêm vào giờ nào?"),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => extraClassTime = time);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                extraClassTime == null
                    ? "Chọn giờ"
                    : "Giờ: ${extraClassTime!.format(context)}",
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSurveyDone() ? _finishSurvey : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Hoàn thành khảo sát",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSurveyDone() {
    return selectedGrade != null &&
        selectedPlayTime != null &&
        selectedSubjects.isNotEmpty &&
        selectedExtraClass != null &&
        selectedStudyTimes.isNotEmpty &&
        selectedExtraSubjects.isNotEmpty &&
        selectedExtraDays.isNotEmpty &&
        extraClassTime != null;
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildToggleRadio(
    List<String> items,
    String? groupValue,
    Function(String) onChange,
  ) {
    return Column(
      children: items.map((item) {
        final selected = item == groupValue;
        return GestureDetector(
          onTap: () => onChange(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? Colors.teal.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? Colors.teal : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
                ),
                Icon(
                  selected ? Icons.radio_button_checked : Icons.circle_outlined,
                  color: selected ? Colors.teal : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
