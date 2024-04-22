import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tum_ai/object_detection.dart';
import 'face_detection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFaceDetection = true;

  void _toggleDetection() {
    setState(() {
      _isFaceDetection = !_isFaceDetection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade100,
            elevation: 5,
            title:  Text(_isFaceDetection?"Face Detection":'Object Detection'),
            actions: [
              Icon(Icons.table_bar),
              Switch(
                value: _isFaceDetection,
                onChanged: (value) {
                  _toggleDetection();
                },
              ),
              const Icon(Icons.face_retouching_natural),
            ],
          ),
          body: _isFaceDetection?
          FaceDetectionPage(
              initialWidth: MediaQuery.of(context).size.width):
          ObjectDetectionPage(
              initialWidth: MediaQuery.of(context).size.width)),
    );
  }
}
