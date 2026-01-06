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
      return col
          .where('approved', isEqualTo: true)
          .snapshots();
    }

    return col
        .where('approved', isEqualTo: true)
        .where('grade', isEqualTo: _selectedGrade)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diễn đàn học tập")),
      body: Column(
        children: [
          const SizedBox(height: 8),

          /// FILTER
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final g = _grades[i];
                return ChoiceChip(
                  label: Text(g),
                  selected: _selectedGrade == g,
                  selectedColor: Colors.teal,
                  labelStyle: TextStyle(
                    color: _selectedGrade == g
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (_) =>
                      setState(() => _selectedGrade = g),
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
                if (snap.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Chưa có bài viết nào"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (_, i) {
                    final m = snap.data!.docs[i].data()
                        as Map<String, dynamic>;
                    final post = ForumPost.fromMap(m);
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

/// ================= POST CARD =================
class _PostCard extends StatelessWidget {
  final ForumPost post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.author,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(post.title),
          ],
        ),
      ),
    );
  }
}

/// ================= CREATE =================
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
      appBar: AppBar(
        title: const Text("Tạo bài"),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text("Đăng"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _grade,
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
              onChanged: (v) => setState(() => _grade = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration:
                  const InputDecoration(hintText: "Tiêu đề"),
            ),
          ],
        ),
      ),
    );
  }
}
