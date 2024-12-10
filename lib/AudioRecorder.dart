import 'dart:async';

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
    if (!_isRecorderInitialized) {
      print("Recorder is not initialized");
      return;
    }
    if (!_recorder.isRecording) {
      print("Starting the recorder...");
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
        numChannels: 1,
        sampleRate: 44100,
      );
      print('Recording started');
    } else {
      print('Recorder is already running.');
    }

    // Check if the recording process stays active
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_recorder.isRecording) {
        print("Recording in progress...");
      } else {
        print("Recording stopped unexpectedly.");
        timer.cancel();
      }
    });
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

