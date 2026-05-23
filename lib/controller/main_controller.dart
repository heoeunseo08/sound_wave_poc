import 'package:flutter/services.dart';

class MainController {
  static const MethodChannel _record = MethodChannel('com.example.audio/record');
  static const EventChannel _event = EventChannel('com.example.audio/event');

  // 앱 전체에서 하나의 stream만 존재 → 여러 화면이 동시에 listen해도 충돌 없음
  static final Stream<List<double>> _sharedWaveform = _buildStream();

  static Stream<List<double>> _buildStream() {
    final amplitudes = <double>[];
    return _event.receiveBroadcastStream().map((event) {
      final pcm = Uint8List.fromList(List<int>.from(event));
      int sum = 0;
      for (int i = 0; i < pcm.length - 1; i += 2) {
        int sample = pcm[i] | (pcm[i + 1] << 8);
        if (sample > 32767) sample -= 65536;
        sum += sample.abs();
      }
      final amplitude = (sum / (pcm.length / 2)) / 32768.0;
      final clamped = amplitude.clamp(0.0, 1.0);
      amplitudes.add(clamped);
      if (amplitudes.length > 60) amplitudes.removeAt(0);
      return List<double>.from(amplitudes);
    }).asBroadcastStream();
  }

  Stream<List<double>> get waveform => _sharedWaveform;

  Future<void> startRecord() async {
    try {
      await _record.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      print("false: ${e.message}");
    }
  }

  Future<void> stopRecord() async {
    try {
      await _record.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      print("false: ${e.message}");
    }
  }
}