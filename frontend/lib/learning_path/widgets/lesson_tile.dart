import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonTile extends StatelessWidget {
  final String title;
  final int index;
  final bool isDone;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.title,
    required this.index,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDone
                    ? Colors.green.withOpacity(0.15)
                    : Colors.blue[50],
                child: Icon(
                  isDone ? Icons.check_rounded : Icons.play_arrow_rounded,
                  size: 20,
                  color: isDone ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
