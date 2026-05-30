import 'package:flutter/material.dart';

class SoundWaveWidget extends StatefulWidget {
  const SoundWaveWidget({super.key});

  @override
  State<SoundWaveWidget> createState() => _SoundWaveWidgetState();
}

class _SoundWaveWidgetState extends State<SoundWaveWidget> {
  var amplitude = ValueNotifier(0.0);
  var phase = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: Listenable.merge([amplitude, phase]),
        builder: (context, child) {

        },),
    );
  }
}
