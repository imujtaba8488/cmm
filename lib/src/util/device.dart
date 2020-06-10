import 'package:flutter/material.dart';

class Device {
  BuildContext _context;
  Orientation _orientation;
  EdgeInsets _padding;
  double _height;
  double _width;
  Block _block;

  Device(BuildContext context) {
    _context = context;
    _orientation = MediaQuery.of(context).orientation;
    _padding = MediaQuery.of(context).padding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _block = Block(height / 100, width / 100);
  }

  Orientation get orientation => _orientation;

  BuildContext get context => _context;

  EdgeInsets get padding => _padding;

  double get height => _height;

  double get width => _width;

  Block get block => _block;
}

class Block {
  double _height;
  double _width;

  Block(this._height, this._width);

  double get height => _height;
  
  double get width => _width;
}
