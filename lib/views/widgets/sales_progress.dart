import 'package:flutter/material.dart';

class SalesProgressPage extends StatelessWidget {
  const SalesProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بياناتك:
    const int sold = 491;
    const int total = 1200;
    final double progress = sold / total; // النسبة المئوية

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SalesProgressIndicator(
          sold: sold,
          total: total,
          progress: progress,
        ),
      ),
    );
  }
}

class SalesProgressIndicator extends StatelessWidget {
  final int sold;
  final int total;
  final double progress;

  const SalesProgressIndicator({
    super.key,
    required this.sold,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الخلفية الرمادية
        CustomPaint(
          size: const Size(150, 100),
          painter: HalfCirclePainter(
            progress: 1.0,
            color: Colors.grey.shade300,
          ),
        ),
        // الجزء الأصفر حسب النسبة
        CustomPaint(
          size: const Size(220, 100),
          painter: HalfCirclePainter(
            progress: progress,
            color: Colors.amber,
          ),
        ),
        // النصوص فوق الشكل
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$sold",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "SOLD",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "OUT OF",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$total",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// الرسام المسؤول عن الخط المنحني
class HalfCirclePainter extends CustomPainter {
  final double progress; // من 0 إلى 1
  final Color color;

  HalfCirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final double startAngle = -3.14 / 2; // بداية من اليسار
    final double sweepAngle = 3.14 * progress; // نصف دائرة مضروبة في النسبة

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
