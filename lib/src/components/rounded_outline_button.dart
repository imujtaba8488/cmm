import 'package:flutter/material.dart';

class RoundedOutlineButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color borderColor;
  final EdgeInsets padding;

  RoundedOutlineButton({
    @required this.label,
    @required this.onPressed,
    this.borderColor = Colors.transparent,
    this.padding = const EdgeInsets.all(5.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: onPressed,
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
