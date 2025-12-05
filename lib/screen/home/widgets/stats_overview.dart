import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsOverview extends StatelessWidget {
  final int lessons;
  final String time;
  final int certificates;

  const StatsOverview({
    super.key,
    required this.lessons,
    required this.time,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.book,
        'value': lessons.toString(),
        'label': "Bài đã học",
        'color': Colors.blue,
      },
      {
        'icon': Icons.timer,
        'value': time,
        'label': "Thời gian",
        'color': Colors.orange,
      },
      {
        'icon': Icons.workspace_premium,
        'value': certificates.toString(),
        'label': "Chứng chỉ",
        'color': Colors.purple,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((e) => _statItem(e)).toList(),
    );
  }

  Widget _statItem(Map e) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (e['color'] as Color).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(e['icon'], color: e['color']),
        ),
        const SizedBox(height: 6),
        Text(
          e['value'],
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          e['label'],
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
