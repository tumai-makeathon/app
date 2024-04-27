import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tum_ai/polygon_data.dart';

final double phoneSizeCutOff = 800;

class ForestVision extends StatefulWidget {
  const ForestVision({Key? key}) : super(key: key);

  @override
  State<ForestVision> createState() => _ForestVisionState();
}

const Color kBackground = Color(0xFF051f20);

class _ForestVisionState extends State<ForestVision> {
  List<List<LatLng>> polyGonList = [];
  // [[LatLng(-9.537428, -56.503603), LatLng( -9.454869,  -56.503998), LatLng( -9.417477,  -56.552564), LatLng( -9.481157,  -56.553748), LatLng( -9.483689,  -56.560855), LatLng( -9.504329,  -56.561448), LatLng( -9.499461,  -56.547431), LatLng( -9.504913,  -56.540718), LatLng( -9.537039,  -56.503406), LatLng( -9.454674,  -56.504591), LatLng( -9.416114,  -56.553353), LatLng( -9.483494,  -56.553748), LatLng( -9.505692,  -56.559276), LatLng( -9.500045,  -56.547036), LatLng( -9.508418,  -56.541113), LatLng( -9.526525,  -56.529071), LatLng( -9.53587,  -56.505183)]];
  int currentPolyGonIndex = 0;
  MapController mapController = MapController();
  bool showPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              color: kBackground,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        onTap: (pos, point) {
                          addPointToPolyGon(point);
                          setState(() {});
                          // mapController.
                        },
                        center: const LatLng(-8.830068, -57.049248),
                        zoom: 11.0,
                      ),
                      children: [
                        backgroundMapLayer(),
                        ...List.generate(
                            polyGonList.length,
                            (index) => PolygonLayer(
                                  polygons: [
                                    Polygon(
                                        isFilled: true,
                                        points: polyGonList[index],
                                        color:
                                            Colors.redAccent.withOpacity(0.5),
                                        borderStrokeWidth: 2,
                                        borderColor:
                                            Colors.redAccent.withOpacity(0.9))
                                  ],
                                )),
                        ...List.generate(
                            polygonData.length,
                            (index) => PolygonLayer(
                                  polygons: [
                                    Polygon(
                                        isFilled: true,
                                        points: polygonData[index],
                                        color:
                                            Colors.blueAccent.withOpacity(0.2),
                                        borderStrokeWidth: 2,
                                        borderColor:
                                            Colors.blueAccent.withOpacity(0.9))
                                  ],
                                )),
                        PolygonLayer(
                          polygons: [
                            Polygon(
                                isFilled: true,
                                points: problematicArea,
                                color: Colors.redAccent.withOpacity(0.2),
                                borderStrokeWidth: 2,
                                borderColor: Colors.redAccent.withOpacity(0.9))
                          ],
                        ),
                        MarkerLayer(markers: [
                          Marker(
                            point: infoPoint,
                            child: IconButton(
                                onPressed: () {
                                  if (MediaQuery.of(context).size.width <
                                      phoneSizeCutOff) {
                                    showModalBottomSheet(
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      backgroundColor: kBackground,
                                        context: context,
                                        enableDrag: true,
                                        builder: (context) =>
                                            const HistoricalDataPage());
                                  }

                                  setState(() {
                                    showPage = !showPage;
                                  });
                                },
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.redAccent.withOpacity(0.7),
                                  size: 24,
                                )),
                          )
                        ])
                      ],
                    )),
              ),
            )),
            MediaQuery.of(context).size.width < phoneSizeCutOff
                ? Container()
                : Container(
                    width: 400,
                    color: kBackground,
                    child: showPage
                        ? const HistoricalDataPage()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 150,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset("assets/logo.jpg")),
                              ),
                              const SizedBox(height: 20),
                              const Text("Forest Vision",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                              Text("Index: $currentPolyGonIndex",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              // TextButton(
                              //     onPressed: () {
                              //       setState(() {
                              //         currentPolyGonIndex++;
                              //       });
                              //     },
                              //     child: const Text("Increment Index")),
                              // TextButton(
                              //     onPressed: () {
                              //       print(polyGonList);
                              //     },
                              //     child: const Text("Print PolyGon List")),
                              // TextButton(
                              //     child: const Text("Remove last point"),
                              //     onPressed: () {
                              //       if (polyGonList.length > 0) {
                              //         polyGonList[currentPolyGonIndex]
                              //             .removeLast();
                              //         setState(() {});
                              //       }
                              //     }),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  void addPointToPolyGon(LatLng point) {
    if (polyGonList.length == 0) {
      polyGonList.add([]);
    }
    if (polyGonList.length <= currentPolyGonIndex) {
      polyGonList.add([]);
    }
    polyGonList[currentPolyGonIndex].add(point);
  }
}

TileLayer backgroundMapLayer() {
  return TileLayer(
    urlTemplate: googleSatelite,
    userAgentPackageName: 'dev.flutter_map.example',
  );
}

class HistoricalDataPage extends StatelessWidget {
  const HistoricalDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Historical Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            CoverImages(title: "2024", index: 3),
            CoverImages(title: "2023", index: 2),
            CoverImages(title: "2022", index: 1),
          ],
        ),
      ),
    );
  }
}

String googleHybrid = "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}";
String googleSatelite = "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}";
String googleRoadUrl = "https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}";
String erisTileURL =
    "http://services.arcgisonline.com/ArcGis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png";
String topoURL = "http://c.tile.opentopomap.org/{z}/{x}/{y}.png";
String opentStreetMapUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

class CoverImages extends StatelessWidget {
  final String title;
  final int index;
  const CoverImages({Key? key, required this.title, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(25),
        //     border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
        child: Row(
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/cover_$index.png",
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Divider(
              color: Colors.white.withOpacity(0.3),
              thickness: 2,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
