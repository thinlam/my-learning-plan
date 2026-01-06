import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String title;
  final String author;
  final String grade; // Lớp 10 | 11 | 12 | Đại học
  final bool approved;
  final DateTime createdAt;

  ForumPost({
    required this.title,
    required this.author,
    required this.grade,
    required this.approved,
    required this.createdAt,
  });

  factory ForumPost.fromMap(Map<String, dynamic> m) {
    return ForumPost(
      title: m['title'],
      author: m['author'],
      grade: m['grade'],
      approved: m['approved'],
      createdAt: (m['createdAt'] as Timestamp).toDate(),
    );
  }
}
