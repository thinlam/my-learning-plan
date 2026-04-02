import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonPage extends StatefulWidget {
  final String title;
  final int index;

  const LessonPage({super.key, required this.title, required this.index});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool isDone = false;
  bool isFavorite = false;

  final TextEditingController _noteC = TextEditingController();

  @override
  void dispose() {
    _noteC.dispose();
    super.dispose();
  }

  // Gửi kết quả cho PathDetailPage
  void _markCompletedAndPop() {
    Navigator.pop(context, true); // 🔥 Gửi "đã hoàn thành"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          "Bài ${widget.index}",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? Colors.amber : Colors.grey[600],
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          // ======= TIÊU ĐỀ =======
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // ======= NỘI DUNG BÀI HỌC =======
          _buildSection(
            title: "Mục tiêu bài học",
            content:
                "• Hiểu kiến thức trọng tâm.\n• Áp dụng vào bài tập.\n• Tránh lỗi thường gặp.",
          ),

          const SizedBox(height: 14),

          _buildSection(
            title: "Nội dung chính",
            content:
                "• Lý thuyết quan trọng.\n"
                "• Ví dụ minh họa.\n"
                "• Phân tích bài mẫu.\n"
                "• Gợi ý mẹo ghi nhớ nhanh.",
          ),

          const SizedBox(height: 20),

          // ======= GHI CHÚ =======
          Text(
            "Ghi chú của bạn",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          TextField(
            controller: _noteC,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Viết lại ý chính hoặc điều bạn muốn ghi nhớ...",
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ======= NÚT HOÀN THÀNH =======
          ElevatedButton.icon(
            onPressed: () {
              setState(() => isDone = true);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Bạn đã hoàn thành bài học!",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );

              // gửi tín hiệu về PathDetailPage
              Future.delayed(const Duration(milliseconds: 400), () {
                _markCompletedAndPop();
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: isDone ? Colors.green : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(
              isDone ? Icons.check_circle : Icons.check_circle_outline,
              color: Colors.white,
            ),
            label: Text(
              isDone ? "Đã hoàn thành bài học" : "Đánh dấu hoàn thành",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget gọn để tạo block nội dung học
  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 2), blurRadius: 8, color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.45,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
