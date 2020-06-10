import 'dart:math';

import 'package:flutter/material.dart';

/// Returns the given [percent] of the [value] provided. For example, 10% for 100 = 10.
class PercentOf {
  final num value;

  PercentOf(this.value);

  /// Formula for percentage is: '% of value, wherein, % = 1 / 100'.
  num percent(int percent) => (value / 100) * percent;
}

/// Returns the given [part] of the [value] provided. For example, 10th part of 100 = 10.
class PartOf {
  final num value;

  PartOf(this.value);

  num part(int part) => (value / part);
}

class Device {
  final BuildContext context;
  PercentOf width, height;

  Device(this.context) {
    width = PercentOf(MediaQuery.of(context).size.width);
    height = PercentOf(MediaQuery.of(context).size.height);
  }
}

/// Returns the center of any shape with a height and a width. 
/// Based on Pythagorus Theorem: (h) square = (b) square + (l) square.
/// Review: Write detailed doc later.
/// Created with the help of 'ISRA ITRAT RAFIQI' on September, 2019.
double centerOf(double height, double width) {
  double l = height * height;
  double b = width * width;
  double h = l + b;

  return h = sqrt(h) / 2.0;
}

/// Returns the center of a given rectangle. 
double centerOfRect(Rect rect) {
  double l = rect.size.height * rect.size.height;
  double b = rect.size.width * rect.size.width;
  double h = l * b;

  return h = sqrt(h) / 2.0;
}
