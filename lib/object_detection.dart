import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';

class ObjectDetectionCameraPage extends StatefulWidget {
  final double initialWidth;
  const ObjectDetectionCameraPage({super.key, required this.initialWidth});

  @override
  State<ObjectDetectionCameraPage> createState() => _ObjectDetectionCameraPageState();
}

class _ObjectDetectionCameraPageState extends State<ObjectDetectionCameraPage> {
  double width = 100;
  double height = 100;
  List<DetectedObject> objects = [];
  double scaleFactorHeight = 1;
  double scaleFactorWidth = 1;
  XFile? currentImageFile;

  @override
  void initState() {
    super.initState();
    width = widget.initialWidth;
  }

  void _incrementCounter() async {
    width = widget.initialWidth;
    setState(() {
      this.objects = [];
    });
    final filePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (filePath == null) {
      return;
    }
    setState(() {
      currentImageFile = filePath;
    });
    final decodedImage =
        await decodeImageFromList(await currentImageFile!.readAsBytes());
    final imageHeight = decodedImage.height; // Image height
    final imageWidth = decodedImage.width;

    final inputImage = InputImage.fromFilePath(filePath.path);

    // Use DetectionMode.stream when processing camera feed.
// Use DetectionMode.single when processing a single image.
    final mode = DetectionMode.single;

    final options = ObjectDetectorOptions(
        mode: mode, classifyObjects: false, multipleObjects: false);

// Options to configure the detector while using a Firebase model.
//     final options = FirebaseObjectDetectorOptions();

    final objectDetector = ObjectDetector(options: options);
    final List<DetectedObject> objects =
        await objectDetector.processImage(inputImage);

    print("Objects: ${objects.length}");
    for (DetectedObject detectedObject in objects) {

      // final rect = detectedObject.boundingBox;
      final trackingId = detectedObject.trackingId;

      print("label($trackingId): ${detectedObject.labels}");

      for (Label label in detectedObject.labels) {
        print('${label.text} ${label.confidence}');
      }
    }
    setState(() {
      this.objects = objects;
    });

    height = (width / imageWidth) * imageHeight;

    scaleFactorHeight = height / imageHeight;
    scaleFactorWidth = width / imageWidth;
  }

  @override
  Widget build(BuildContext context) {
    print("scaleFactorHeight: $scaleFactorHeight");
    print("scaleFactorWidth: $scaleFactorWidth");
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Colors.grey,
            width: width.toDouble(),
            height: height.toDouble(),
            child: currentImageFile == null
                ? const Text('No image selected.')
                : Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.file(File(currentImageFile!.path)),
                      ...List.generate(
                          objects.length,
                          (index) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    objects[index].boundingBox.left *
                                        scaleFactorWidth,
                                    objects[index].boundingBox.top *
                                        scaleFactorHeight,
                                    0,
                                    0
                                    // faces[index].boundingBox.right *
                                    //     scaleFactorWidth,
                                    // faces[index].boundingBox.bottom *
                                    //     scaleFactorHeight,
                                    ),
                                width: objects[index].boundingBox.width *
                                    scaleFactorWidth,
                                height: objects[index].boundingBox.height *
                                    scaleFactorHeight,
                              ))
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
