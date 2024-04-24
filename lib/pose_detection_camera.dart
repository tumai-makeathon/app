import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionCameraPage extends StatefulWidget {
  final double initialWidth;
  const PoseDetectionCameraPage({super.key, required this.initialWidth});

  @override
  State<PoseDetectionCameraPage> createState() => _PoseDetectionCameraPageState();
}

class _PoseDetectionCameraPageState extends State<PoseDetectionCameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  PoseDetector? _poseDetector;
  bool _isDetecting = false;
  List<Pose> _lastPoses = [];
  List<Pose> _poses = [];
  double width = 100;
  double height = 100;
  double scaleFactorHeight = 1;
  double scaleFactorWidth = 1;

  @override
  void initState() {
    width = widget.initialWidth;
    super.initState();
    _initializeCamera();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if(_cameras == null) {
      print('No camera found');
      return;
    }
    _controller = CameraController(_cameras!.first, ResolutionPreset.medium);
    await _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _controller?.startImageStream((image) => _processCameraImage(image));
    });
  }

  void _processCameraImage(CameraImage image) async {
    height =image.height.toDouble();
    width = image.width.toDouble();
    if (_isDetecting) return;
    _isDetecting = true;

    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotation.rotation90deg; // Simplified for example

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    final List<Pose> poses = await _poseDetector!.processImage(inputImage);
    if (!mounted) return;
    setState(() {
      _lastPoses = _poses;
      _poses = poses;
    });
    _isDetecting = false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _controller==null?Center(child: CircularProgressIndicator(),):
      _controller!.value.isInitialized
          ? Stack(
              children: [
                SizedBox(
                    width: width,
                    height: height,
                    child: CameraPreview(_controller!)),
                ..._poses
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
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;

  PosePainter({required this.pose, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (final PoseLandMarkType in pose.landmarks.keys) {
      final landmark = pose.landmarks[PoseLandMarkType]!;

      canvas.drawCircle(Offset(
          landmark.x , landmark.y ), 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
