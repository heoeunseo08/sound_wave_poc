import 'package:flutter/material.dart';
import 'package:poc1/controller/main_controller.dart';
import 'package:poc1/utils/line_waveform_painter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isRecording = false;
  final controller = MainController();
  List<double> amplitudes = [];

  @override
  void initState() {
    super.initState();
    controller.waveform.listen((event) {
      setState(() {
        amplitudes =  event;
      });
      print("pcm:${event.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: .symmetric(vertical: 55),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 150),
              painter: LineWaveformPainter(amplitudes: amplitudes),
            ),
            GestureDetector(
              onTap: () {
                setState(() => isRecording = !isRecording);
                if (isRecording) {
                  controller.startRecord();
                } else
                  controller.stopRecord();
              },
              child: Icon(
                isRecording ? Icons.square : Icons.mic,
                size: isRecording ? 35 : 50,
                color: isRecording ? Colors.red : Color(0xff00bbd2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
