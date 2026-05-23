import 'package:flutter/material.dart';

class AudioWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final double gain;

  AudioWaveformPainter({required this.amplitudes, this.gain = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    final strokePaint = Paint()
      ..color = const Color(0xff00bbd2)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // idle 상태: 수평 중앙선
    if (amplitudes.length < 2) {
      canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), strokePaint);
      return;
    }

    final paint = Paint()
      ..color = Color(0xff00bbd2)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (amplitudes.length - 1);

    double boost(double v) => (v * gain).clamp(0.0, 1.0);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * stepX;
      final dy = boost(amplitudes[i]) * size.height * 0.45;

      if (i == 0) {
        path.moveTo(x, centerY - dy);
      } else {
        final preX = (i - 1) * stepX;
        final preDy = boost(amplitudes[i - 1]) * size.height * 0.45;
        final controlX = (preX + x) / 2;
        path.cubicTo(
          controlX,
          centerY - preDy,
          controlX,
          centerY - dy,
          x,
          centerY - dy,
        );
      }
    }

    for (int i = amplitudes.length - 1; i >= 0; i--) {
      final x = i * stepX;
      final dy = boost(amplitudes[i]) * size.height * 0.45;

      if (i == amplitudes.length - 1) {
        path.lineTo(x, centerY + dy);
      } else {
        final nextX = (i + 1) * stepX;
        final nextDy = boost(amplitudes[i + 1]) * size.height * 0.45;
        final controlX = (nextX + x) / 2;
        path.cubicTo(
          controlX,
          centerY + nextDy,
          controlX,
          centerY + dy,
          x,
          centerY + dy,
        );
      }
    }

    path.close();

    final fillPaint = Paint()
      ..color = const Color(0xff00bbd2)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AudioWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
