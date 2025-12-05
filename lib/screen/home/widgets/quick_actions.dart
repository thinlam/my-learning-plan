import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onPaths;
  final VoidCallback? onQuiz;
  final VoidCallback? onReminder;

  const QuickActions({
    super.key,
    this.onContinue,
    this.onPaths,
    this.onQuiz,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.play_arrow_rounded,
        'label': 'Tiếp tục',
        'onTap': onContinue,
      },
      {'icon': Icons.list_alt_rounded, 'label': 'Lộ trình', 'onTap': onPaths},
      {'icon': Icons.quiz_rounded, 'label': 'Quiz', 'onTap': onQuiz},
      {
        'icon': Icons.notifications_active_outlined,
        'label': 'Nhắc nhở',
        'onTap': onReminder,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e) => _buildActionItem(e)).toList(),
    );
  }

  Widget _buildActionItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: item['onTap'],
      child: Column(
        children: [
          // Icon tròn
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade100.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(item['icon'], color: Colors.teal.shade700, size: 22),
          ),

          const SizedBox(height: 6),

          // Label
          Text(
            item['label'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
