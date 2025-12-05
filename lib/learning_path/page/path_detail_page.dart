import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/lesson_tile.dart';
import '../page/lesson_page.dart';

import '../../learning_path/Ai/ai_learning_path_model.dart';

class PathDetailPage extends StatefulWidget {
  /// 🔹 Nhận nguyên AiLearningPath từ trang AI
  final AiLearningPath path;

  const PathDetailPage({super.key, required this.path});

  @override
  State<PathDetailPage> createState() => _PathDetailPageState();
}

class _PathDetailPageState extends State<PathDetailPage> {
  late List<bool> completed; // trạng thái các bài học

  @override
  void initState() {
    super.initState();

    // Đảm bảo không vượt quá lessonCount
    final safeCompleted = widget.path.completedLessons.clamp(
      0,
      widget.path.lessonCount,
    );

    completed = List.generate(
      widget.path.lessonCount,
      (i) => i < safeCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.path;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          path.title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng quan lộ trình",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${path.lessonCount} bài học • Mức độ: ${path.difficulty}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- LIST LESSONS ----------------
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: path.lessonCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lessonTitle =
                    "Bài ${index + 1}: Nội dung trọng tâm cho \"${path.title}\"";

                return LessonTile(
                  index: index + 1,
                  title: lessonTitle,
                  isDone: completed[index],

                  onTap: () async {
                    // 👉 Mở trang bài học
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LessonPage(title: lessonTitle, index: index + 1),
                      ),
                    );

                    // 👉 Sau khi học xong → đánh dấu hoàn thành
                    setState(() {
                      completed[index] = true;

                      // Cập nhật số bài đã hoàn thành trong model AI
                      widget.path.completedLessons = completed
                          .where((e) => e)
                          .length;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
