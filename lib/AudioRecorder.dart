import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorder {
  String TAG = "AudioRecorder" + " MyLog ";
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> startRecording(String path) async {
    if (!_isRecorderInitialized) return;
    if (!_recorder.isRecording) {
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV, // Explicitly specify a compatible codec
      );
      print('Recording started');
    } else {
      print('Recorder is already running.');
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) return;
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
      print('Recording stopped');
    } else {
      print('Recorder is not running.');
    }
  }

  void dispose() {
    if (_isRecorderInitialized) _recorder.closeRecorder();
  }
}

