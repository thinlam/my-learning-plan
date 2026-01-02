import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoftSkillsPage extends StatefulWidget {
  const SoftSkillsPage({super.key});

  @override
  State<SoftSkillsPage> createState() => _SoftSkillsPageState();
}

class _SoftSkillsPageState extends State<SoftSkillsPage> {
  // Dummy progress – sau này gắn Firebase
  double progress = 0.4;

  final List<Map<String, dynamic>> roadmap = [
    {
      "title": "Giao tiếp hiệu quả",
      "desc": "Lắng nghe, trình bày, phản hồi",
      "icon": Icons.forum,
      "done": true,
    },
    {
      "title": "Quản lý thời gian",
      "desc": "Lập kế hoạch, ưu tiên công việc",
      "icon": Icons.schedule,
      "done": true,
    },
    {
      "title": "Làm việc nhóm",
      "desc": "Hợp tác, giải quyết xung đột",
      "icon": Icons.groups,
      "done": false,
    },
    {
      "title": "Tư duy & lãnh đạo",
      "desc": "Phản biện, ra quyết định",
      "icon": Icons.psychology,
      "done": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Kỹ năng mềm"),
        backgroundColor: Colors.teal,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildProgressCard(),
          const SizedBox(height: 24),
          _buildRoadmap(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.white, size: 42),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lộ trình Kỹ năng mềm",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Phát triển kỹ năng toàn diện",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PROGRESS
  // ================================================================
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tiến độ Kỹ năng mềm",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Hoàn thành ${(progress * 100).toStringAsFixed(0)}%",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ROADMAP
  // ================================================================
  Widget _buildRoadmap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nội dung học",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        ...roadmap.map(_roadmapItem).toList(),
      ],
    );
  }

  Widget _roadmapItem(Map<String, dynamic> item) {
    final bool done = item["done"] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: done
                  ? Colors.green.withOpacity(0.15)
                  : Colors.teal.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item["icon"], color: done ? Colors.green : Colors.teal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["desc"],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          done
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.lock_outline, color: Colors.grey),
        ],
      ),
    );
  }

  // ================================================================
  // CARD STYLE
  // ================================================================
  BoxDecoration _card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
