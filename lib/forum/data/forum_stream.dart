import 'package:cloud_firestore/cloud_firestore.dart';
import 'forum_post.dart';

class ForumStream {
  static final _col =
      FirebaseFirestore.instance.collection('forum_posts');

  /// USER – chỉ lấy bài đã duyệt
  static Stream<List<ForumPost>> approvedPosts() {
    return _col
        .where('approved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapDocs);
  }

  /// ADMIN – bài chờ duyệt theo lớp
  static Stream<List<ForumPost>> pendingByGrade(String grade) {
    return _col
        .where('approved', isEqualTo: false)
        .where('grade', isEqualTo: grade)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapDocs);
  }

  static List<ForumPost> _mapDocs(QuerySnapshot snap) {
    return snap.docs.map((d) {
      final m = d.data() as Map<String, dynamic>;

      return ForumPost(
        title: m['title'],
        author: m['author'],
        grade: m['grade'],
        approved: m['approved'],
        createdAt: (m['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }
}
