import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Icon icon;
  final Widget child;
  final Function onPressed;

  CustomButton({this.icon, @required this.child, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) icon,
            if (icon != null) SizedBox(width: 5.0),
            child,
          ],
        ),
      ),
    );
  }
}
