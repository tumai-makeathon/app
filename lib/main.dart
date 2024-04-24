import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tum_ai/object_detection.dart';
import 'package:tum_ai/position_detection.dart';
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

enum ScreenSelection { face, object, pose }

extension ScreenSelectionExtension on ScreenSelection {
  String get name {
    switch (this) {
      case ScreenSelection.face:
        return 'Face Detection';
      case ScreenSelection.object:
        return 'Object Detection';
      case ScreenSelection.pose:
        return 'Pose Detection';
    }
  }

  IconData get icon {
    switch (this) {
      case ScreenSelection.face:
        return Icons.face;
      case ScreenSelection.object:
        return Icons.image_search;
      case ScreenSelection.pose:
        return Icons.person;
    }
  }
}

class _MyAppState extends State<MyApp> {
  ScreenSelection _selectedScreen = ScreenSelection.face;
  void setSelectedScreen(ScreenSelection screen) {
    setState(() {
      _selectedScreen = screen;
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
            backgroundColor: Colors.purple.shade200,
            elevation: 5,
            title: Text(_selectedScreen.name),
            actions: [
              SelectableIconButton(
                screen: ScreenSelection.face,
                setSelectedScreen: setSelectedScreen,
                isSelected: _selectedScreen == ScreenSelection.face,
              ),
              SelectableIconButton(
                screen: ScreenSelection.object,
                setSelectedScreen: setSelectedScreen,
                isSelected: _selectedScreen == ScreenSelection.object,
              ),
              SelectableIconButton(
                screen: ScreenSelection.pose,
                setSelectedScreen: setSelectedScreen,
                isSelected: _selectedScreen == ScreenSelection.pose,
              ),
            ],
          ),
          body: _selectedScreen == ScreenSelection.face
              ? FaceDetectionPage(
                  initialWidth: MediaQuery.of(context).size.width)
              : _selectedScreen == ScreenSelection.object
                  ? ObjectDetectionPage(
                      initialWidth: MediaQuery.of(context).size.width)
                  : PoseDetectionPage(
                      initialWidth: MediaQuery.of(context).size.width)),
    );
  }
}

class SelectableIconButton extends StatelessWidget {
  final bool isSelected;
  final ScreenSelection screen;
  final Function(ScreenSelection) setSelectedScreen;
  const SelectableIconButton(
      {Key? key,
      required this.screen,
      required this.setSelectedScreen,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(screen.icon),
        onPressed: () {
          setSelectedScreen(screen);
        },
      ),
    );
  }
}
