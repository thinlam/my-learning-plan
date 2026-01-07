import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/forum_post.dart';
import '../data/forum_service.dart';

class ForumUI extends StatefulWidget {
  const ForumUI({super.key});

  @override
  State<ForumUI> createState() => _ForumUIState();
}

class _ForumUIState extends State<ForumUI> {
  static const _grades = [
    "Tất cả",
    "Lớp 10",
    "Lớp 11",
    "Lớp 12",
    "Đại học",
  ];

  String _selectedGrade = "Tất cả";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f2f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Diễn đàn học tập",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          /// FILTER
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final g = _grades[i];
                return ChoiceChip(
                  label: Text(
                    g,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _selectedGrade == g
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  selected: _selectedGrade == g,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onSelected: (_) =>
                      setState(() => _selectedGrade = g),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          /// LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _postStream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(child: Text("Chưa có bài viết nào"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (_, i) {
                    final doc = snap.data!.docs[i];
                    final post = ForumPost.fromDoc(doc);
                    return _PostCard(post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),

      /// CREATE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.edit),
        label: const Text("Tạo bài"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForumCreateUI(
                initialGrade:
                    _selectedGrade == "Tất cả" ? "Lớp 10" : _selectedGrade,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ================= POST CARD =================
class _PostCard extends StatelessWidget {
  final ForumPost post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xffe4e6eb),
                  child: Icon(Icons.person, color: Colors.black54),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        post.grade,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey.shade600),
              ],
            ),

            const SizedBox(height: 12),

            /// CONTENT
            Text(post.title, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 14),
            const Divider(height: 1),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LikeButton(postId: post.id),
                _CommentButton(post: post),
                const _Action(
                  icon: Icons.share_outlined,
                  label: "Chia sẻ",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= LIKE =================
class _LikeButton extends StatelessWidget {
  final String postId;

  const _LikeButton({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ForumService.isLiked(postId),
      builder: (_, likedSnap) {
        final liked = likedSnap.data ?? false;

        return StreamBuilder<int>(
          stream: ForumService.likeCount(postId),
          builder: (_, countSnap) {
            final count = countSnap.data ?? 0;

            return TextButton.icon(
              onPressed: () => ForumService.toggleLike(postId),
              icon: Icon(
                Icons.thumb_up_alt,
                size: 18,
                color: liked ? Colors.blue : Colors.grey.shade700,
              ),
              label: Text(
                "Thích ($count)",
                style: TextStyle(
                  color: liked ? Colors.blue : Colors.grey.shade700,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// ================= COMMENT =================
class _CommentButton extends StatelessWidget {
  final ForumPost post;

  const _CommentButton({required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: ForumService.commentCount(post.id),
      builder: (_, snap) {
        final count = snap.data ?? 0;

        return TextButton.icon(
          onPressed: () => _showCommentSheet(context),
          icon: const Icon(Icons.comment_outlined, size: 18),
          label: Text("Bình luận ($count)"),
        );
      },
    );
  }

  void _showCommentSheet(BuildContext context) {
    final ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Bình luận",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: ForumService.comments(post.id),
                  builder: (_, snap) {
                    if (!snap.hasData) return const SizedBox();

                    return ListView(
                      children: snap.data!.docs.map((d) {
                        final m =
                            d.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(m['user'] ?? 'Ẩn danh'),
                          subtitle: Text(m['content']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(
                          hintText: "Viết bình luận...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        ForumService.addComment(
                          postId: post.id,
                          content: ctrl.text,
                        );
                        ctrl.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ================= ACTION =================
class _Action extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Action({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.grey.shade700),
      label: Text(
        label,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }
}

/// ================= CREATE POST UI =================
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

  Future<void> _submit() async {
    await ForumService.createPost(
      title: _titleCtrl.text.isEmpty
          ? "Bài viết mới"
          : _titleCtrl.text,
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
      backgroundColor: const Color(0xfff0f2f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tạo bài viết",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              "Đăng",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _grade,
                    decoration:
                        const InputDecoration(border: InputBorder.none),
                    items: const [
                      DropdownMenuItem(
                          value: "Lớp 10", child: Text("Lớp 10")),
                      DropdownMenuItem(
                          value: "Lớp 11", child: Text("Lớp 11")),
                      DropdownMenuItem(
                          value: "Lớp 12", child: Text("Lớp 12")),
                      DropdownMenuItem(
                          value: "Đại học", child: Text("Đại học")),
                    ],
                    onChanged: (v) =>
                        setState(() => _grade = v!),
                  ),
                  const Divider(),
                  TextField(
                    controller: _titleCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Bạn đang nghĩ gì?",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
