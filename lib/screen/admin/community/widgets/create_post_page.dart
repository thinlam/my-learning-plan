import 'package:flutter/material.dart';
import 'feeling_picker.dart';

class CreatePostPage extends StatefulWidget {
  final Function(String) onPost;

  const CreatePostPage({super.key, required this.onPost});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _controller = TextEditingController();
  String? feeling;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  bool get canPost => _controller.text.trim().isNotEmpty || feeling != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo bài viết"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: canPost
                ? () {
                    widget.onPost(_buildPostText());
                    Navigator.pop(context);
                  }
                : null,
            child: Text(
              "Đăng",
              style: TextStyle(
                color: canPost ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("ADMIN", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Giáo viên / Quản trị nhóm"),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Nhập nội dung bài viết...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          if (feeling != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(feeling!),
                  onDeleted: () => setState(() => feeling = null),
                ),
              ),
            ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.emoji_emotions, color: Colors.orange),
            title: const Text("Cảm xúc / Hoạt động"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeelingPicker(
                    onSelect: (f) => setState(() => feeling = f),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _buildPostText() {
    if (feeling != null && _controller.text.trim().isNotEmpty) {
      return "${_controller.text.trim()}\n$feeling";
    }
    if (feeling != null) return feeling!;
    return _controller.text.trim();
  }
}
