import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [2, 3, 4, 1, 5, 4, 3]; // giờ học demo

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 8, color: Colors.black12),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: data[index] * 20.0,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ["T2", "T3", "T4", "T5", "T6", "T7", "CN"][index],
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
