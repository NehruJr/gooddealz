import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';

class SalesProgress extends StatelessWidget {
  final int sold;
  final int total;

  const SalesProgress({
    super.key,
    required this.sold,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double progress = sold / total;

    return CustomPaint(
      painter: RectProgressPainter(progress),
      child: SizedBox(
        width: 148,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$sold',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: AppColors.yBlackColor,
                      ),
                    ),
                    Text(
                      'SOLD'.tr,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                width: 2,
                color: Colors.grey.shade300,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OUT OF'.tr,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.yBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RectProgressPainter extends CustomPainter {
  final double progress;
  RectProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
    final radius = 25.0;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.yPrimaryColor, AppColors.ySecondry2Color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // الخلفية الرمادية
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    canvas.drawPath(path, backgroundPaint);

    // مسار الإطار
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isNotEmpty) {
      final metric = pathMetrics.first;
      final length = metric.length * progress;
      final progressPath = metric.extractPath(0, length);
      canvas.drawPath(progressPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(RectProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
