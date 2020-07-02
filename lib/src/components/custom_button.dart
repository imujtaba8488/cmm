import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  CustomButton({@required this.child, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
