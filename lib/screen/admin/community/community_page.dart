import 'package:flutter/material.dart';
import 'group_feed_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== DATA GIẢ: CÁC NHÓM THEO MÔN =====
    final groups = [
      {"name": "Nhóm Toán 12", "subject": "Toán", "members": 25},
      {"name": "Nhóm Vật Lý 11", "subject": "Vật Lý", "members": 18},
      {"name": "Nhóm Hóa 10", "subject": "Hóa", "members": 20},
      {"name": "Nhóm Tiếng Anh", "subject": "Anh Văn", "members": 30},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Cộng đồng môn học (ADMIN)")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (_, i) {
          final g = groups[i];
          return _GroupCard(
            name: g["name"] as String,
            subject: g["subject"] as String,
            members: g["members"] as int,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupFeedPage(groupName: g["name"] as String),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String name;
  final String subject;
  final int members;
  final VoidCallback onTap;

  const _GroupCard({
    required this.name,
    required this.subject,
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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$members thành viên · $subject",
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
