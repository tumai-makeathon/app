import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tum_ai/forest_detection_example.dart';
import 'package:tum_ai/forest_vision.dart';
import 'package:tum_ai/object_detection.dart';
import 'package:tum_ai/pose_detection_camera.dart';
import 'package:tum_ai/pose_detection_image.dart';
import 'face_detection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum ScreenSelection { face, object, poseCamera, poseImage }

extension ScreenSelectionExtension on ScreenSelection {
  String get name {
    switch (this) {
      case ScreenSelection.face:
        return 'Face Detection';
      case ScreenSelection.object:
        return 'Object Detection';
      case ScreenSelection.poseCamera:
        return 'Pose Detection';
      case ScreenSelection.poseImage:
        return 'Pose Detection Image';
    }
  }

  IconData get icon {
    switch (this) {
      case ScreenSelection.face:
        return Icons.face;
      case ScreenSelection.object:
        return Icons.image_search;
      case ScreenSelection.poseCamera:
        return Icons.sports_handball_outlined;
      case ScreenSelection.poseImage:
        return Icons.person;
    }
  }

  Widget Function(BuildContext) get page {
    switch (this) {
      case ScreenSelection.face:
        return (context) => FaceDetectionPage(
              initialWidth: MediaQuery.of(context).size.width,
            );
      case ScreenSelection.object:
        return (context) => ObjectDetectionCameraPage(
              initialWidth: MediaQuery.of(context).size.width,
            );
      case ScreenSelection.poseCamera:
        return (context) => PoseDetectionCameraPage(
              initialWidth: MediaQuery.of(context).size.width,
            );
      case ScreenSelection.poseImage:
        return (context) => PoseDetectionImagePage(
              initialWidth: MediaQuery.of(context).size.width,
            );
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: ForestDetectionExample());
    MaterialApp(
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
                screen: ScreenSelection.poseCamera,
                setSelectedScreen: setSelectedScreen,
                isSelected: _selectedScreen == ScreenSelection.poseCamera,
              ),
              SelectableIconButton(
                screen: ScreenSelection.poseImage,
                setSelectedScreen: setSelectedScreen,
                isSelected: _selectedScreen == ScreenSelection.poseImage,
              ),
            ],
          ),
          body: _selectedScreen.page(context)),
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
