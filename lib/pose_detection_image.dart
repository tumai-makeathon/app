import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';

class PoseDetectionImagePage extends StatefulWidget {
  final double initialWidth;
  const PoseDetectionImagePage({super.key, required this.initialWidth});

  @override
  State<PoseDetectionImagePage> createState() => _PoseDetectionImagePageState();
}

class _PoseDetectionImagePageState extends State<PoseDetectionImagePage> {
  double width = 100;
  double height = 100;
  List<Pose> poses = [];
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
      poses = [];
    });
    final filePath = await ImagePicker().pickImage(source: ImageSource.camera);
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

    final poseDetector = PoseDetector(options: PoseDetectorOptions());
    final List<Pose> detectedPoses =
        await poseDetector.processImage(inputImage);

    print("Poses detected: ${detectedPoses.length}");

    setState(() {
      poses = detectedPoses;
    });

    height = (width / imageWidth) * imageHeight;

    scaleFactorHeight = height / imageHeight;
    scaleFactorWidth = width / imageWidth;

    print("scalefactor: $scaleFactorHeight, $scaleFactorWidth");

    for (final pose in detectedPoses) {
      for (final PoseLandmark landmark in pose.landmarks.values) {
        print(
            'Landmark ${landmark.type}: (${landmark.x}, ${landmark.y}) with confidence ${landmark.likelihood}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Image.file(File(currentImageFile!.path),
                          width: width, height: height, fit: BoxFit.fill),
                      ...poses
                          .expand((pose) => pose.landmarks.values
                              .map((landmark) => Positioned(
                                    left: landmark.x * scaleFactorWidth - 5,
                                    top: landmark.y * scaleFactorHeight - 5,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: landmark.likelihood > 0.5
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ),
                                        Text(
                                          landmark.type
                                              .toString()
                                              .split(".")[1],
                                          style: TextStyle(fontSize: 6),
                                        ),
                                      ],
                                    ),
                                  )))
                          .toList(),
                      Positioned(
                          left: 1486.99365234375* 0.09523809523809523,
                          top: 2822*0.09523809523809523,
                          child: Container(
                            color: Colors.red,
                            height: 10,
                            width: 10,
                          ))
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Detect Pose',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
