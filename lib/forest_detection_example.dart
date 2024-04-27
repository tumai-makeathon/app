import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tum_ai/forest_vision.dart';

Color kDarkGreen = const Color(0xFF153c4b);
Color kLightGreen = const Color(0xFF99c6bb);


class ForestDetectionExample extends StatefulWidget {
  const ForestDetectionExample({Key? key}) : super(key: key);

  @override
  State<ForestDetectionExample> createState() => _ForestDetectionExampleState();
}

class _ForestDetectionExampleState extends State<ForestDetectionExample> {
  final LatLng start = const LatLng(-8.85763, -61.502428);
  final MapController mapController = MapController();
  final double gridSize = 10;
  final double gridStepSize = 0.003;
  List<Polygon> grid = [];
  Timer? timer;
  int currentPaintInteration = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    while (true) {
      if (currentPaintInteration >= gridSize * gridSize) {
        return;
      }
      paintGrid();
      await Future.delayed(
          Duration(milliseconds: doubleInRange(Random(), 200, 1000).toInt()));
      if (currentPaintInteration >= gridSize * gridSize) {
        break;
      }
    }
  }

  void paintGrid() {
    grid = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        bool isForest = true;
        bool wasRun = false;
        if (currentPaintInteration < i * gridSize + j) {
          wasRun = true;
        }
        if (i < 2) {
          isForest = false;
        }
        if (i == 1 && j > 8) {
          isForest = true;
        }
        if (i == 2 && (j > 5 || j == 1)) {
          isForest = false;
        }
        if (i == 3 && (j == 8 || j < 2)) {
          isForest = false;
        }
        if (i == 4 && (j == 0)) {
          isForest = false;
        }

        grid.add(Polygon(
          points: [
            LatLng(start.latitude + i * gridStepSize,
                start.longitude + j * gridStepSize),
            LatLng(start.latitude + i * gridStepSize,
                start.longitude + (j + 1) * gridStepSize),
            LatLng(start.latitude + (i + 1) * gridStepSize,
                start.longitude + (j + 1) * gridStepSize),
            LatLng(start.latitude + (i + 1) * gridStepSize,
                start.longitude + j * gridStepSize),
          ],
          color: isForest
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          borderColor: !wasRun
              ? isForest
                  ? Colors.green.withOpacity(0.5)
                  : Colors.red.withOpacity(0.5)
              : Colors.grey,
          isFilled: !wasRun,
          borderStrokeWidth: 1,
        ));
      }
    }
    setState(() {
      currentPaintInteration++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Forest Detection Example",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Container(
                height: 400,
                width: 400,
                child: Container(
                    color: kBackground,
                    height: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Expanded(
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      maxZoom: 15,
                                      minZoom: 10,
                                      // cameraConstraint: CameraConstraint.contain(
                                      //   bounds: LatLngBounds(
                                      //       LatLng(
                                      //           center.latitude +
                                      //               gridSize * gridStepSize,
                                      //           center.longitude +
                                      //               gridSize * gridStepSize),
                                      //       LatLng(
                                      //           center.latitude -
                                      //               gridSize * gridStepSize,
                                      //           center.longitude -
                                      //               gridSize * gridStepSize)),
                                      // ),
                                      // no interaction given
                                      interactiveFlags: InteractiveFlag.all,
                                      onTap: (pos, point) {
                                        setState(() {});
                                        // mapController.
                                      },
                                      center: LatLng(
                                          start.latitude +
                                              0.5 * gridStepSize * gridSize,
                                          start.longitude +
                                              0.5 * gridStepSize * gridSize),
                                      zoom: 14.0,
                                    ),
                                    children: [
                                      backgroundMapLayer(),
                                      PolygonLayer(
                                        polygons: grid,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )))),
              ),
              Spacer(),
              InkWell(
                mouseCursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForestVision(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kLightGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        child: Row(
                          children: [
                            Text(
                              "Look at the Product",
                              style: TextStyle(
                                fontSize: 20,
                                color: kDarkGreen,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: kDarkGreen,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ));
  }
}

double doubleInRange(Random source, num start, num end) =>
    source.nextDouble() * (end - start) + start;
