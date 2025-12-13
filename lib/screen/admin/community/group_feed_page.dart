import 'package:flutter/material.dart';
import 'widgets/create_post_box.dart';
import 'widgets/post_card.dart';

class GroupFeedPage extends StatelessWidget {
  const GroupFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Nhóm Toán 12"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGroupInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const CreatePostBox(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                PostCard(
                  author: "Giáo viên Toán",
                  content:
                      "📌 Tuần này học chương 3. Các em nhớ làm bài tập trước thứ 6.",
                  time: "2 giờ trước",
                ),
                PostCard(
                  author: "Nguyễn Văn A",
                  content: "Thầy ơi bài 5 trang 72 em chưa hiểu 😥",
                  time: "1 giờ trước",
                ),
                PostCard(
                  author: "Trần Thị B",
                  content: "Em đã hoàn thành bài tập rồi ạ 👍",
                  time: "30 phút trước",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thông tin nhóm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text("• Môn: Toán"),
            Text("• Khối: 12"),
            Text("• Thành viên: 25"),
            Text("• Mục tiêu: Trao đổi & hỗ trợ học tập"),
          ],
        ),
      ),
    );
  }
}
