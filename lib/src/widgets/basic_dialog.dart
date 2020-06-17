import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  final Widget child;

  BasicDialog({this.child});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: child,
      ),
    );
  }
}
