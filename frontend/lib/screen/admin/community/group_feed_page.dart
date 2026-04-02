import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/post_card.dart';
import 'package:my_learning_plan/forum/data/forum_setting.dart';

class GroupFeedPage extends StatefulWidget {
  final String grade;

  const GroupFeedPage({super.key, required this.grade});

  @override
  State<GroupFeedPage> createState() => _GroupFeedPageState();
}

class _GroupFeedPageState extends State<GroupFeedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  Stream<QuerySnapshot> _approvedStream() {
    return FirebaseFirestore.instance
        .collection('forum_posts')
        .where('approved', isEqualTo: true)
        .where('grade', isEqualTo: widget.grade)
        .snapshots();
  }

  Stream<QuerySnapshot> _pendingStream() {
    return FirebaseFirestore.instance
        .collection('forum_posts')
        .where('approved', isEqualTo: false)
        .where('grade', isEqualTo: widget.grade)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grade),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: "Bài viết"),
            Tab(text: "Chờ duyệt"),
            Tab(text: "Cài đặt"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _approvedTab(),
          _pendingTab(),
          _settingsTab(),
        ],
      ),
    );
  }

  Widget _approvedTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _approvedStream(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.data!.docs.isEmpty) {
          return const Center(child: Text("Chưa có bài viết"));
        }

        return ListView(
          children: snap.data!.docs.map((d) {
            final m = d.data() as Map<String, dynamic>;
            return PostCard(
              author: m['author'],
              content: m['title'],
              time: "Đã duyệt",
              isAdmin: true,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _pendingTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _pendingStream(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.data!.docs.isEmpty) {
          return const Center(
              child: Text("Không có bài chờ duyệt"));
        }

        return ListView(
          children: snap.data!.docs.map((d) {
            final m = d.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(m['author']),
              subtitle: Text(m['title']),
              trailing: ElevatedButton(
                onPressed: () {
                  d.reference.update({'approved': true});
                },
                child: const Text("Duyệt"),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _settingsTab() {
    return SwitchListTile(
      value: ForumSetting.requireApproval,
      title: const Text("Bật duyệt bài"),
      onChanged: (v) =>
          setState(() => ForumSetting.requireApproval = v),
    );
  }
}
