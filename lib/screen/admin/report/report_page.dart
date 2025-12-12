import 'package:flutter/material.dart';

enum ReportRange { day, week, month, year }

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportRange selectedRange = ReportRange.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Báo cáo tiến độ học tập"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FilterTabs(
            selected: selectedRange,
            onChanged: (v) => setState(() => selectedRange = v),
          ),

          const SizedBox(height: 20),

          /// ===== BIỂU ĐỒ (FULL – TO)
          _ReportCard(
            title: "Tiến độ học tập",
            child: SizedBox(
              height: 420, // 🔥 TO RÕ RÀNG
              width: double.infinity,
              child: CustomPaint(painter: _LineChartPainter(selectedRange)),
            ),
          ),

          const SizedBox(height: 24),

          const _ReportCard(
            title: "Nhận xét",
            child: Text(
              "Biểu đồ thể hiện mức độ hoàn thành lộ trình học theo "
              "khoảng thời gian đã chọn (ngày, tuần, tháng, năm). "
              "Dữ liệu được mô phỏng nhằm minh họa cho chức năng báo cáo.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final ReportRange selected;
  final ValueChanged<ReportRange> onChanged;

  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ReportRange.values.map((e) {
        final isActive = e == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(e),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? Colors.indigo : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.35),
                      blurRadius: 10,
                    ),
                ],
              ),
              child: Text(
                _label(e),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _label(ReportRange r) {
    switch (r) {
      case ReportRange.day:
        return "Ngày";
      case ReportRange.week:
        return "Tuần";
      case ReportRange.month:
        return "Tháng";
      case ReportRange.year:
        return "Năm";
    }
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ReportCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final ReportRange range;
  _LineChartPainter(this.range);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 60.0;
    const bottomPadding = 40.0;
    const topPadding = 20.0;
    const rightPadding = 20.0;

    final axisPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.indigo;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final data = _fakeData(range);

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    /// ===== GRID + TRỤC Y (%)
    for (int i = 0; i <= 5; i++) {
      final y = topPadding + chartHeight * i / 5;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: "${100 - i * 20}%",
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftPadding - 45, y - 7));
    }

    /// ===== TRỤC X + LABEL
    for (int i = 0; i < data.length; i++) {
      final x = leftPadding + chartWidth * i / (data.length - 1);

      textPainter.text = TextSpan(
        text: _xLabel(range, i),
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - bottomPadding + 8),
      );
    }

    /// ===== TRỤC CHÍNH
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, size.height - bottomPadding),
      axisPaint,
    );
    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width - rightPadding, size.height - bottomPadding),
      axisPaint,
    );

    /// ===== ĐƯỜNG BIỂU ĐỒ
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = leftPadding + chartWidth * i / (data.length - 1);
      final y = topPadding + chartHeight * (1 - data[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  /// ===== DATA GIẢ (MOCK)
  List<double> _fakeData(ReportRange r) {
    switch (r) {
      case ReportRange.day:
        return [0.4, 0.5, 0.45, 0.6, 0.55];
      case ReportRange.week:
        return [0.3, 0.45, 0.6, 0.7, 0.8];
      case ReportRange.month:
        return [0.2, 0.4, 0.55, 0.7, 0.9];
      case ReportRange.year:
        return [0.25, 0.4, 0.6, 0.75, 0.85];
    }
  }

  /// ===== LABEL TRỤC X
  String _xLabel(ReportRange r, int i) {
    switch (r) {
      case ReportRange.day:
        return "D${i + 1}";
      case ReportRange.week:
        return "T${i + 1}";
      case ReportRange.month:
        return "Th${i + 1}";
      case ReportRange.year:
        return "N${i + 1}";
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
