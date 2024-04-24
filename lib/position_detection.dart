import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionPage extends StatefulWidget {
  final double initialWidth;
  const PoseDetectionPage({super.key, required this.initialWidth});

  @override
  State<PoseDetectionPage> createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  PoseDetector? _poseDetector;
  bool _isDetecting = false;
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
        InputImageRotation.rotation0deg; // Simplified for example

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
    setState(() {
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
                CameraPreview(_controller!),
                ..._poses.map((pose) => CustomPaint(
                      painter: PosePainter(
                          pose: pose,
                          imageSize: Size(_controller!.value.previewSize!.width,
                              _controller!.value.previewSize!.height)),
                    )),
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

    for (final PoseLandmark landmark in pose.landmarks.values) {
      canvas.drawCircle(Offset(landmark.x, landmark.y), 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
