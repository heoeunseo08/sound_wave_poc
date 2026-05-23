import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poc1/controller/main_controller.dart';
import 'package:poc1/utils/audio_waveform_painter.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool isRecording = false;
  final controller = MainController();
  List<double> amplitudes = [];
  StreamSubscription<List<double>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = controller.waveform.listen((event) {
      if (mounted) {
        setState(() {
          amplitudes = event;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: .symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 250),
            painter: AudioWaveformPainter(amplitudes: amplitudes, gain: 4.0),
          ),
          GestureDetector(
            onTap: () {
              setState(() => isRecording = !isRecording);
              if (isRecording) {
                controller.startRecord();
              } else {
                controller.stopRecord();
              }
            },
            child: Icon(
              isRecording ? Icons.square : Icons.mic,
              size: isRecording ? 35 : 50,
              color: isRecording ? Colors.red : const Color(0xff00bbd2),
            ),
          ),
        ],
      ),
    );
  }
}