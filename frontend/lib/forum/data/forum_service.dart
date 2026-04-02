import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForumService {
  static final _db = FirebaseFirestore.instance;
  static final _col = _db.collection('forum_posts');

  /// ================= CREATE POST =================
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

  /// ================= LIKE =================

  /// Toggle like / unlike
  static Future<void> toggleLike(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref =
        _col.doc(postId).collection('likes').doc(user.uid);

    final snap = await ref.get();

    if (snap.exists) {
      await ref.delete();
    } else {
      await ref.set({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Realtime số like
  static Stream<int> likeCount(String postId) {
    return _col
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((s) => s.docs.length);
  }

  /// Realtime user đã like chưa
  static Stream<bool> isLiked(String postId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(false);
    }

    return _col
        .doc(postId)
        .collection('likes')
        .doc(user.uid)
        .snapshots()
        .map((d) => d.exists);
  }

  /// ================= COMMENT =================

  /// Thêm comment
  static Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || content.trim().isEmpty) return;

    await _col.doc(postId).collection('comments').add({
      'user': 'Học sinh',
      'uid': user.uid,
      'content': content.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Realtime danh sách comment
  static Stream<QuerySnapshot> comments(String postId) {
    return _col
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Realtime số comment
  static Stream<int> commentCount(String postId) {
    return _col
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((s) => s.docs.length);
  }
}
