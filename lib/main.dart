import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

import 'AudioRecorder.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudioRecorderScreen(),
    );
  }
}

class AudioRecorderScreen extends StatefulWidget {
  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _audioRecorder.initRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/audio_record3.wav';
    print('MyLog path: ' + path);
    try {
      print('Starting recording...');
      await _audioRecorder.startRecording(path);
      print('Recording started');
    } catch (e) {
      print('Error starting recorder: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      print('Stopping recording...');
      await Future.delayed(Duration(seconds: 20));
      await _audioRecorder.stopRecording();
      setState(() {
        _recordingPath = null;
      });
      print('Recording stopped');
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Recorder')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                print(_recordingPath == null ? 'startRecording assigned' : 'null assigned');
                if (_recordingPath == null) {
                  startRecording();
                }
              },
              child: Text('Start Recording'),

            ),
            ElevatedButton(
              onPressed: stopRecording, //_recordingPath != null ? stopRecording : null,
              child: Text('Stop Recording'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> requestPermissions() async {
  await Permission.microphone.request();
  await Permission.storage.request();
}
