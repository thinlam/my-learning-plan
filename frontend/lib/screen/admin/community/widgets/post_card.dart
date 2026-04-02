import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String author;
  final String content;
  final String time;
  final bool isAdmin;

  const PostCard({
    super.key,
    required this.author,
    required this.content,
    required this.time,
    this.isAdmin = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (widget.isAdmin)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Chip(
                              label: Text("ADMIN"),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      widget.time,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (widget.isAdmin)
                PopupMenuButton(
                  itemBuilder: (_) => const [
                    PopupMenuItem(child: Text("Ghim bài viết")),
                    PopupMenuItem(child: Text("Ẩn bài viết")),
                    PopupMenuItem(child: Text("Khoá bình luận")),
                    PopupMenuItem(child: Text("Xoá bài viết")),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),
          Text(widget.content),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // ===== ACTION BAR =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PostAction(
                icon: liked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                label: "Thích",
                color: liked ? Colors.blue : Colors.grey,
                onTap: () => setState(() => liked = !liked),
              ),
              const _PostAction(
                icon: Icons.comment_outlined,
                label: "Bình luận",
                color: Colors.grey,
              ),
              const _PostAction(
                icon: Icons.share_outlined,
                label: "Chia sẻ",
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _PostAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
