import 'package:flutter/material.dart';
import 'create_post_page.dart';
import 'slide_from_top_route.dart';

class CreatePostBox extends StatelessWidget {
  final Function(String) onPost;

  const CreatePostBox({super.key, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ===== INPUT =====
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.of(
                context,
              ).push(SlideFromTopRoute(page: CreatePostPage(onPost: onPost)));
            },
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfff0f2f5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      "Bạn đang nghĩ gì?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // ===== ACTION BUTTONS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _ActionItem(icon: Icons.image, color: Colors.green, label: "Ảnh"),
              _ActionItem(
                icon: Icons.videocam,
                color: Colors.red,
                label: "Video",
              ),
              _ActionItem(
                icon: Icons.emoji_emotions,
                color: Colors.orange,
                label: "Cảm xúc",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _ActionItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
