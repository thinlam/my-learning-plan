import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/forum_post.dart';
import '../data/forum_setting.dart';
import '../data/forum_service.dart';

class ForumUI extends StatefulWidget {
  const ForumUI({super.key});

  @override
  State<ForumUI> createState() => _ForumUIState();
}

class _ForumUIState extends State<ForumUI> {
  static const _grades = ["Tất cả", "Lớp 10", "Lớp 11", "Lớp 12", "Đại học"];

  String _selectedGrade = "Tất cả";

  // ===== LOGIC GIỮ NGUYÊN =====
  Stream<QuerySnapshot> _postStream() {
    final col = FirebaseFirestore.instance.collection('forum_posts');

    if (_selectedGrade == "Tất cả") {
      return col.where('approved', isEqualTo: true).snapshots();
    }

    return col
        .where('approved', isEqualTo: true)
        .where('grade', isEqualTo: _selectedGrade)
        .snapshots();
  }

  int _readInt(Map<String, dynamic> m, List<String> keys, {int fallback = 0}) {
    for (final k in keys) {
      final v = m[k];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Diễn đàn học tập",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          /// FILTER (UI đẹp)
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final g = _grades[i];
                final selected = _selectedGrade == g;

                return ChoiceChip(
                  label: Text(g),
                  selected: selected,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  selectedColor: Colors.teal,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pressElevation: 0,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selected ? Colors.teal : Colors.black12,
                      width: 1,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                  onSelected: (_) => setState(() => _selectedGrade = g),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _postStream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return _EmptyState(grade: _selectedGrade);
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (_, i) {
                    final doc = snap.data!.docs[i];
                    final docId = doc.id;

                    final m = doc.data() as Map<String, dynamic>;
                    final post = ForumPost.fromMap(m); // giữ nguyên

                    // Đọc count (tự chịu được bạn đặt tên field khác)
                    final likeCount = _readInt(m, const [
                      "likeCount",
                      "likes",
                    ], fallback: 0);
                    final commentCount = _readInt(m, const [
                      "commentCount",
                      "comments",
                    ], fallback: 0);

                    return _PostCard(
                      postId: docId,
                      post: post,
                      likeCount: likeCount,
                      commentCount: commentCount,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      /// CREATE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text("Tạo bài"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForumCreateUI(
                initialGrade: _selectedGrade == "Tất cả"
                    ? "Lớp 10"
                    : _selectedGrade,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ================= EMPTY STATE UI =================
class _EmptyState extends StatelessWidget {
  final String grade;
  const _EmptyState({required this.grade});

  @override
  Widget build(BuildContext context) {
    final text = grade == "Tất cả"
        ? "Chưa có bài viết nào"
        : "Chưa có bài viết cho $grade";

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum_outlined, size: 46, color: Colors.teal),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              "Hãy tạo bài viết đầu tiên để chia sẻ câu hỏi hoặc kinh nghiệm học tập.",
              style: TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= POST CARD (Like + Comment thật) =================
class _PostCard extends StatelessWidget {
  final String postId;
  final ForumPost post;
  final int likeCount;
  final int commentCount;

  const _PostCard({
    required this.postId,
    required this.post,
    required this.likeCount,
    required this.commentCount,
  });

  Future<void> _like(BuildContext context) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('forum_posts')
          .doc(postId);
      await ref.update({'likeCount': FieldValue.increment(1)});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi like: $e")));
    }
  }

  Future<void> _openCommentSheet(BuildContext context) async {
    final ctrl = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Viết bình luận",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Nhập bình luận...",
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final text = ctrl.text.trim();
                    if (text.isEmpty) return;

                    try {
                      final postRef = FirebaseFirestore.instance
                          .collection('forum_posts')
                          .doc(postId);

                      // 1) add comment
                      await postRef.collection('comments').add({
                        'text': text,
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                      // 2) increment comment count
                      await postRef.update({
                        'commentCount': FieldValue.increment(1),
                      });

                      if (ctx.mounted) Navigator.pop(ctx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã gửi bình luận")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lỗi bình luận: $e")),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text(
                    "Gửi",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Colors.black12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Nếu có detail thì điều hướng ở đây
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      post.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.teal.withOpacity(.25)),
                    ),
                    child: Text(
                      post.grade,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// TITLE
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 10),
              const Divider(height: 1),

              /// ACTIONS
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    _ActionBtn(
                      icon: Icons.thumb_up_alt_outlined,
                      text: "Thích ($likeCount)",
                      onTap: () => _like(context),
                    ),
                    const SizedBox(width: 10),
                    _ActionBtn(
                      icon: Icons.chat_bubble_outline,
                      text: "Bình luận ($commentCount)",
                      onTap: () => _openCommentSheet(context),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= ACTION BUTTON =================
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.black87),
              const SizedBox(width: 6),
              Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= CREATE (GIỮ LOGIC, UI ĐẸP) =================
class ForumCreateUI extends StatefulWidget {
  final String initialGrade;

  const ForumCreateUI({super.key, required this.initialGrade});

  @override
  State<ForumCreateUI> createState() => _ForumCreateUIState();
}

class _ForumCreateUIState extends State<ForumCreateUI> {
  final _titleCtrl = TextEditingController();
  late String _grade;

  @override
  void initState() {
    super.initState();
    _grade = widget.initialGrade;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  // ===== LOGIC GIỮ NGUYÊN =====
  Future<void> _submit() async {
    await ForumService.createPost(
      title: _titleCtrl.text.isEmpty ? "Bài viết mới" : _titleCtrl.text,
      grade: _grade,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("⏳ Bài viết đang chờ admin duyệt"),
        backgroundColor: Colors.orange,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tạo bài",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _submit,
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
              child: const Text("Đăng"),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            child: DropdownButtonFormField<String>(
              value: _grade,
              decoration: const InputDecoration(
                labelText: "Cấp học",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.school_outlined),
              ),
              items: const [
                DropdownMenuItem(value: "Lớp 10", child: Text("Lớp 10")),
                DropdownMenuItem(value: "Lớp 11", child: Text("Lớp 11")),
                DropdownMenuItem(value: "Lớp 12", child: Text("Lớp 12")),
                DropdownMenuItem(value: "Đại học", child: Text("Đại học")),
              ],
              onChanged: (v) => setState(() => _grade = v ?? _grade),
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            child: TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: "Tiêu đề",
                hintText: "VD: Cách học Toán lớp 11 hiệu quả",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.title),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.teal.withOpacity(.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Bài viết sẽ hiển thị sau khi admin duyệt.",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: child,
    );
  }
}
