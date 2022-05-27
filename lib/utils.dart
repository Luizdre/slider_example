import 'dart:math';

import 'package:flutter/material.dart';

List<Color> colors = [
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.orange,
  Colors.yellow,
  Colors.greenAccent,
  Colors.cyan
];

const fullangleInRadians = pi * 2;

double normalize(double value, double max) => (value % max + max) % max;

double normalizeAngle(double angle) => normalize(angle, fullangleInRadians);

double toRadian(double value) => (value * pi) / 180;

double toangle(Offset position, Offset center) => (position - center).direction;

Offset toPolar(Offset center, double radians, double radius) =>
    center + Offset.fromDirection(radians, radius);
