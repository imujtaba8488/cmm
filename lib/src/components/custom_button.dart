import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Icon icon;
  final Widget child;
  final Function onPressed;
  final bool disabled;

  CustomButton({
    this.icon,
    @required this.child,
    @required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: disabled? Colors.grey: Colors.green,
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
      ),
    );
  }
}
