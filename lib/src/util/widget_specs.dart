import 'package:flutter/material.dart';

import 'device.dart';

class WidgetSpecs {
  Device _device;
  double height;
  double width;
  double fontSize;

  WidgetSpecs(BuildContext context) {
    _device = Device(context);

    // Review: Later
    if (_device.height < 700 && _device.height > 500) {
      height = _device.block.height * 8;
      width = _device.block.width * 100;
      fontSize = 18;
    } else if (_device.height < 500) {
      height = _device.block.height * 12;
      width = _device.block.width * 100;
      fontSize = 18;
    }
  }
}
