import 'package:flutter/material.dart';
import 'group_feed_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Cộng đồng học tập"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GroupCard(
            name: "Nhóm Toán 12",
            members: "25 thành viên",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GroupFeedPage()),
            ),
          ),
          _GroupCard(
            name: "Thi đua tuần",
            members: "40 thành viên",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GroupFeedPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String name;
  final String members;
  final VoidCallback onTap;

  const _GroupCard({
    required this.name,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.group, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    members,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
