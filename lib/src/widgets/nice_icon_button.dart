import 'package:flutter/material.dart';

class NiceIconButton extends StatelessWidget {
  final Icon icon;
  final Text label;
  final Function onPressed;

  NiceIconButton({
    this.icon = const Icon(Icons.add),
    this.label = const Text(''),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            label,
            icon,
          ],
        ),
      ),
    );
  }
}
