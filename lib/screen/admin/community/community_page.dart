import 'package:flutter/material.dart';
import 'group_feed_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      {"name": "Lớp 10", "grade": "Lớp 10", "members": 120},
      {"name": "Lớp 11", "grade": "Lớp 11", "members": 98},
      {"name": "Lớp 12", "grade": "Lớp 12", "members": 85},
      {"name": "Đại học", "grade": "Đại học", "members": 60},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cộng đồng theo lớp (ADMIN)"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (_, i) {
          final g = groups[i];
          return _GroupCard(
            name: g["name"] as String,
            members: g["members"] as int,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupFeedPage(
                    grade: g["grade"] as String, // ✅ CHỈ GRADE
                  ),
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
  final int members;
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.teal,
              child: Icon(Icons.school, color: Colors.white),
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
                    "$members thành viên",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
