import 'package:flutter/material.dart';

class LineWaveformPainter extends CustomPainter {
  final List<double> amplitudes;

  LineWaveformPainter({required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = Color(0xff00bbd2)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;
    final stepX = size.width / (amplitudes.length - 1);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * stepX;
      final y = centerY - (amplitudes[i] * size.height * 0.8);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final preX = (i - 1) * stepX;
        final preY = centerY - (amplitudes[i - 1] * size.height * 0.8);
        final controlX = (preX + x)/2;
        path.cubicTo(controlX, preY, controlX, y, x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LineWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
