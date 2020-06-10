import 'package:flutter/material.dart';

/// A combination of Icon and Text, hence the name 'Icoxt'.
class IcoxtBar extends StatelessWidget {
  final List<IcoxtBarItem> items;
  final paddingAround;

  IcoxtBar({this.items, this.paddingAround = const EdgeInsets.all(5.0)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAround,
      child: Row(
        // Pay attention!
        mainAxisAlignment: items.length > 2
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: items,
      ),
    );
  }
}

/// Display an Icon with the given text.
class IcoxtBarItem extends StatelessWidget {
  final Icon icon;
  final String text;

  IcoxtBarItem({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon != null
            ? Icon(
                icon.icon,
                color: Colors.grey,
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(text),
        ),
      ],
    );
  }
}

/// Groups more than one IcoxtBars and displays them row-wise.
class IcoxtBarGroup extends StatelessWidget {
  final List<IcoxtBar> items;

  IcoxtBarGroup({this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }
}
