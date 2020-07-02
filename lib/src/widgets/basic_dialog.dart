import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  final Widget child;
  final double height;
  final bool roundedCornors;
  final double borderWidth;

  BasicDialog({
    this.child,
    this.height,
    this.roundedCornors = true,
    this.borderWidth = 1.5,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: roundedCornors
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            )
          : null,
      child: Container(
        // height: height != null ? height : null,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: borderWidth,
          ),
          borderRadius: roundedCornors ? BorderRadius.circular(5.0) : null,
        ),
        child: child,
      ),
    );
  }
}
