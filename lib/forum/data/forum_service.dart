import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForumService {
  static final _col =
      FirebaseFirestore.instance.collection('forum_posts');

  /// USER tạo bài → LUÔN chờ duyệt
  static Future<void> createPost({
    required String title,
    required String grade,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _col.add({
      'title': title,
      'author': 'Học sinh',
      'grade': grade,
      'approved': false, // ⭐ LUÔN CHỜ DUYỆT
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(), // ⭐ BẮT BUỘC
    });
  }
}
