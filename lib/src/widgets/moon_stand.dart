import 'package:flutter/material.dart';

// todo: documentation still pending...

class MoonStand extends StatefulWidget {
  final Widget top;
  final MoonButton leftButton, rightButton;
  final double height, width;

  MoonStand({
    this.top,
    this.leftButton,
    this.rightButton,
    this.height = 150.0,
    this.width = 150.0,
  });

  @override
  State<StatefulWidget> createState() {
    return MoonStandState();
  }
}

class MoonStandState extends State<MoonStand> {
  double _standHeight, _standWidth, _buttonHeight, _buttonWidth;
  Color _leftButtonColor, _rightButtonColor;

  @override
  void initState() {
    _standHeight = widget.height;
    _standWidth = widget.width;

    // Button height and width are half of circular stand height and width,
    // respectively.
    _buttonHeight = _standHeight / 2.0;
    _buttonWidth = _standWidth / 2.0;
    _leftButtonColor = _rightButtonColor = Colors.white54;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Moonstand in itself is three rectangular containers bound together and
    // clipped into a circular shape. The top part acts as the information
    // display area. The bottom part, on the other hand is divided into left and
    // the right part to hold the left and the right buttons.

    // Since, there is clipping in effect, providing the borders for individual
    // containers does not yeild the expected widget. Instead, the clipped
    // widget is stacked on top of the the Border Circle to achieve bordering
    // around the clipped widget. Finally, to add some 3D effect, the clipped
    // widget alongwith the border circle is stacked on top of the wrapper
    // circle.
    return _wrapperCircle(
      child: Center(
        child: Stack(
          children: <Widget>[
            _borderCircle(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: _standHeight,
                      width: _standWidth,
                      child: ClipOval(
                        child: Stack(
                          children: <Widget>[
                            infoArea(),
                            _leftButton(),
                            _rightButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Wrapper Circle tries to add the 3D effect to the Moonstand.
  Widget _wrapperCircle({Widget child}) {
    return Container(
      height: _standHeight + 10,
      width: _standWidth + 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.white,

        border: Border.all(width: 0.2),
      ),
      child: child,
    );
  }

  /// Border Circle provides the border for the Moonstand.
  Widget _borderCircle({Widget child}) {
    return Container(
      height: _standHeight,
      width: _standWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(width: 0.2),
      ),
      child: child,
    );
  }

  // todo: still needs to be implemented.
  Widget infoArea() {
    return Container(
      height: _standHeight / 2.0,
      width: _standWidth,
      decoration: BoxDecoration(
        // color: Colors.blue.shade200,
        color: Colors.deepPurple,
        border: Border(bottom: BorderSide(width: 0.2)),
      ),
      child: Center(
        child: Text('testing'),
      ),
    );
  }

  Widget _leftButton() {
    return Positioned(
      top: _standHeight / 2.0,
      // left: standWidth / 2.0,
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) {
          _applyButtonColor(color: Colors.grey);
        },
        onTapUp: (TapUpDetails tapUpDetails) {
          _applyButtonColor(color: Colors.white);
        },
        child: Container(
          // Insets are used to align the icon properly.
          padding: EdgeInsets.only(
            bottom: _standHeight / 7,
            left: _standWidth / 12,
          ),
          height: _buttonHeight,
          width: _buttonWidth,
          decoration: BoxDecoration(
            color: _leftButtonColor,
          ),
          child: Icon(
            Icons.add,
            size: _standWidth / 3,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _rightButton() {
    return Positioned(
      top: _standHeight / 2.0,
      left: _standWidth / 2.0,
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) {
          _applyButtonColor(color: Colors.grey, toLeftButton: false);
        },
        onTapUp: (TapUpDetails tapUpDetails) {
          _applyButtonColor(color: Colors.white, toLeftButton: false);
        },
        child: Container(
          // Insets used to align the icon.
          padding: EdgeInsets.only(
            bottom: _standHeight / 7,
            right: _standWidth / 12,
          ),
          height: _buttonHeight,
          width: _buttonWidth,
          decoration: BoxDecoration(
            color: _rightButtonColor,
            border: Border(left: BorderSide(width: 0.2)),
          ),
          child: Icon(
            Icons.add,
            size: _standWidth / 3,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  /// Applies the given color to [_leftButton] by default. However, if
  /// [toLeftButton] is set to false, applies the given color to the [_rightButton].
  void _applyButtonColor({Color color, bool toLeftButton = true}) {
    setState(() {
      toLeftButton ? _leftButtonColor = color : _rightButtonColor = color;
    });
  }
}

class MoonButton {
  Icon icon;
  Function onPressed;

  MoonButton({@required this.icon, @required this.onPressed});
}

// Remember end of line becomes the new current point.

// MoonStand.singleButton, MoonStand.doubleButton
