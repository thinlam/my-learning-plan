import 'package:flutter/material.dart';
import 'widgets/create_post_box.dart';
import 'widgets/post_card.dart';

class GroupFeedPage extends StatefulWidget {
  final String groupName;

  const GroupFeedPage({super.key, required this.groupName});

  @override
  State<GroupFeedPage> createState() => _GroupFeedPageState();
}

class _GroupFeedPageState extends State<GroupFeedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<Map<String, dynamic>> posts = [
    {
      "author": "Giáo viên",
      "content": "📌 Thông báo kiểm tra giữa kỳ",
      "time": "1 giờ trước",
      "approved": true,
    },
    {
      "author": "Học sinh A",
      "content": "Thầy ơi bài 5 em chưa hiểu",
      "time": "30 phút trước",
      "approved": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  void addPost(String text) {
    setState(() {
      posts.insert(0, {
        "author": "ADMIN",
        "content": text,
        "time": "Vừa xong",
        "approved": true,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.groupName} (ADMIN)"),
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
        children: [_postsTab(), _pendingTab(), _settingsTab()],
      ),
    );
  }

  // ===== TAB: BÀI VIẾT =====
  Widget _postsTab() {
    final approved = posts.where((p) => p["approved"]).toList();

    return Column(
      children: [
        CreatePostBox(onPost: addPost),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: approved.map((p) {
              return PostCard(
                author: p["author"],
                content: p["content"],
                time: p["time"],
                isAdmin: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ===== TAB: CHỜ DUYỆT =====
  Widget _pendingTab() {
    final pending = posts.where((p) => !p["approved"]).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: pending.map((p) {
        return Card(
          child: ListTile(
            title: Text(p["author"]),
            subtitle: Text(p["content"]),
            trailing: ElevatedButton(
              child: const Text("Duyệt"),
              onPressed: () {
                setState(() => p["approved"] = true);
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // ===== TAB: CÀI ĐẶT =====
  Widget _settingsTab() {
    return ListView(
      children: [
        SwitchListTile(
          value: true,
          onChanged: null,
          title: Text("Bật duyệt bài viết"),
        ),
        SwitchListTile(
          value: false,
          onChanged: null,
          title: Text("Cho phép học sinh đăng bài"),
        ),
      ],
    );
  }
}
