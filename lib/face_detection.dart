import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionPage extends StatefulWidget {
  final double initialWidth;
  const FaceDetectionPage({super.key, required this.initialWidth});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  double width = 100;
  double height = 100;
  List<Face> faces = [];
  double scaleFactorHeight = 1;
  double scaleFactorWidth = 1;
  XFile? currentImageFile;

  void _incrementCounter() async {
    width = widget.initialWidth;
    setState(() {
      faces = [];
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

    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final List<Face> recfaces = await faceDetector.processImage(inputImage);

    height = (width / imageWidth) * imageHeight;

    scaleFactorHeight = height / imageHeight;
    scaleFactorWidth = width / imageWidth;

    print("Faces: ${recfaces.length}");
    setState(() {
      faces = recfaces;
    });
    for (final face in recfaces) {
      print("Face: ${face.boundingBox}");
    }
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
                          faces.length,
                          (index) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    faces[index].boundingBox.left *
                                        scaleFactorWidth,
                                    faces[index].boundingBox.top *
                                        scaleFactorHeight,
                                    0,
                                    0
                                    // faces[index].boundingBox.right *
                                    //     scaleFactorWidth,
                                    // faces[index].boundingBox.bottom *
                                    //     scaleFactorHeight,
                                    ),
                                width: faces[index].boundingBox.width *
                                    scaleFactorWidth,
                                height: faces[index].boundingBox.height *
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
