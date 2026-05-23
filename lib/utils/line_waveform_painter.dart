import 'package:flutter/material.dart';

class LineWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final double gain;

  LineWaveformPainter({required this.amplitudes, this.gain = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff00bbd2)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;

    // idle 상태: 수평 중앙선
    if (amplitudes.length < 2) {
      canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);
      return;
    }

    final stepX = size.width / (amplitudes.length - 1);
    final path = Path();

    double boost(double v) => (v * gain).clamp(0.0, 1.0);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * stepX;
      final dy = boost(amplitudes[i]) * size.height * 0.45;
      // 짝수 인덱스는 위, 홀수 인덱스는 아래 → 사인파 형태
      final sign = i.isEven ? -1.0 : 1.0;
      final y = centerY + sign * dy;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevDy = boost(amplitudes[i - 1]) * size.height * 0.45;
        final prevSign = (i - 1).isEven ? -1.0 : 1.0;
        final prevY = centerY + prevSign * prevDy;
        final controlX = (prevX + x) / 2;
        path.cubicTo(controlX, prevY, controlX, y, x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LineWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}