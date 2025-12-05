import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectProgress extends StatelessWidget {
  const SubjectProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = {"Toán": 82, "Lý": 74, "Hóa": 65, "Anh": 90, "Văn": 58};

    return Column(
      children: subjects.entries.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 8,
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.key,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "${item.value}%",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: item.value / 100,
                  color: Colors.teal,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
