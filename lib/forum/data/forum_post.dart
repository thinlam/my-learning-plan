import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id; // ⭐ BẮT BUỘC cho like / comment
  final String title;
  final String author;
  final String grade; // Lớp 10 | 11 | 12 | Đại học
  final bool approved;
  final DateTime createdAt;

  ForumPost({
    required this.id,
    required this.title,
    required this.author,
    required this.grade,
    required this.approved,
    required this.createdAt,
  });

  /// 🔥 CÁCH DUY NHẤT DÙNG ĐỂ ĐỌC FIRESTORE
  factory ForumPost.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;

    return ForumPost(
      id: doc.id,
      title: m['title'] ?? '',
      author: m['author'] ?? 'Ẩn danh',
      grade: m['grade'] ?? '',
      approved: m['approved'] ?? false,
      createdAt:
          (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
