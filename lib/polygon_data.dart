import 'package:latlong2/latlong.dart';

List<List<LatLng>> polygonData = [
  [
    const LatLng(-8.998696, -57.391749),
    const LatLng(-8.995138, -57.359114),
    const LatLng(-8.991998, -57.32881),
    const LatLng(-8.928362, -57.342372),
    const LatLng(-8.936527, -57.413152),
    const LatLng(-8.98551, -57.407642),
    const LatLng(-8.984463, -57.394504)
  ],
  [
    const LatLng(-8.824977, -57.073404),
    const LatLng(-8.941033, -57.080117),
    const LatLng(-8.943179, -56.966403),
    const LatLng(-8.849752, -56.967192),
    const LatLng(-8.844327, -56.969721),
    const LatLng(-8.837784, -56.971096),
    const LatLng(-8.838833, -56.974032),
    const LatLng(-8.838031, -56.983278),
    const LatLng(-8.841364, -56.981528),
    const LatLng(-8.843093, -56.981591),
    const LatLng(-8.846364, -56.984402),
    const LatLng(-8.844204, -56.986214),
    const LatLng(-8.842969, -56.990274),
    const LatLng(-8.841179, -56.992711),
    const LatLng(-8.838957, -56.991461),
    const LatLng(-8.836858, -56.990587),
    const LatLng(-8.834327, -56.99446),
    const LatLng(-8.833772, -56.997021),
    const LatLng(-8.834759, -56.998458),
    const LatLng(-8.833586, -56.999333),
    const LatLng(-8.831981, -56.99902),
    const LatLng(-8.831179, -56.998583),
    const LatLng(-8.830994, -57.003269),
    const LatLng(-8.830376, -57.005393),
    const LatLng(-8.835809, -57.011077),
    const LatLng(-8.837537, -57.012952),
    const LatLng(-8.839142, -57.016388),
    const LatLng(-8.840562, -57.019574),
    const LatLng(-8.841735, -57.024072),
    const LatLng(-8.841673, -57.026695),
    const LatLng(-8.842475, -57.02782),
    const LatLng(-8.843031, -57.022822),
    const LatLng(-8.843834, -57.024634),
    const LatLng(-8.845871, -57.027258),
    const LatLng(-8.846179, -57.031318),
    const LatLng(-8.849204, -57.031943),
    const LatLng(-8.849574, -57.034567),
    const LatLng(-8.842722, -57.036066),
    const LatLng(-8.840932, -57.036503),
    const LatLng(-8.839883, -57.033817),
    const LatLng(-8.836056, -57.032693),
    const LatLng(-8.835006, -57.035066),
    const LatLng(-8.835562, -57.038877),
    const LatLng(-8.832969, -57.04475),
    const LatLng(-8.834451, -57.047248),
    const LatLng(-8.830068, -57.049248),
    const LatLng(-8.830006, -57.058743),
    const LatLng(-8.827475, -57.059555),
    const LatLng(-8.825129, -57.057869),
    const LatLng(-8.823771, -57.060742),
    const LatLng(-8.821549, -57.062054),
    const LatLng(-8.821055, -57.065678),
    const LatLng(-8.82303, -57.066864),
    const LatLng(-8.823462, -57.070738),
    const LatLng(-8.824759, -57.073611),
    const LatLng(-8.822907, -57.074736)
  ]
];

List<LatLng> warningArea = [
  const LatLng(-8.893337, -56.971615),
  const LatLng(-8.890397, -56.974803),
  const LatLng(-8.885777, -56.979905),
  const LatLng(-8.884517, -56.984794),
  const LatLng(-8.885987, -56.98777),
  const LatLng(-8.886407, -56.990746),
  const LatLng(-8.887037, -56.99436),
  const LatLng(-8.889137, -56.99606),
  const LatLng(-8.891237, -56.997761),
  const LatLng(-8.892917, -56.997761),
  const LatLng(-8.895648, -56.997974),
  const LatLng(-8.897328, -56.997123),
  const LatLng(-8.894808, -56.992659),
  const LatLng(-8.894808, -56.992234),
  const LatLng(-8.896488, -56.988408),
  const LatLng(-8.900058, -56.990534),
  const LatLng(-8.902158, -56.993297),
  const LatLng(-8.905098, -56.996911),
  const LatLng(-8.906358, -56.99606),
  const LatLng(-8.906358, -56.993722),
  const LatLng(-8.908038, -56.995423),
  const LatLng(-8.910348, -56.995423),
  const LatLng(-8.910558, -56.99436),
  const LatLng(-8.908668, -56.990108),
  const LatLng(-8.908668, -56.987558),
  const LatLng(-8.908458, -56.983094),
  const LatLng(-8.908458, -56.977992),
  const LatLng(-8.910978, -56.976291),
  const LatLng(-8.911818, -56.975016),
  const LatLng(-8.908878, -56.971615),
  const LatLng(-8.904258, -56.969489),
  const LatLng(-8.897748, -56.969914)
];
LatLng warningPoint = const LatLng(-8.898591, -56.980583);

List<LatLng> problematicArea = [
  const LatLng(-8.984672, -57.392596),
  const LatLng(-8.980695, -57.360809),
  const LatLng(-8.994301, -57.359537),
  const LatLng(-8.99765, -57.390901)
];
LatLng problematicPoint = const LatLng(-8.988, -57.375);
