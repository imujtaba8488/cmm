import 'package:flutter/material.dart';

import '../widgets/text_section.dart';

enum Edges {
  flat,
  rounded,
}

class ConfirmActionDialog extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  final TextSection title, description;
  final List<Widget> actionButtons;
  final Edges edges;
  final bool showDivider;

  ConfirmActionDialog({
    this.backgroundColor,
    this.icon,
    this.title,
    this.description,
    this.actionButtons,
    this.edges = Edges.rounded,
    this.showDivider = true,
  }) {
    assert(title != null);
  }

  // Observe: the recipe: Container -> Material -> Column.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            color: backgroundColor,
            borderRadius:
                edges == Edges.rounded ? BorderRadius.circular(3.0) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                icon != null ? _customizedIcon() : Container(),
                title != null ? _paddedTitle(title) : Container(),
                showDivider
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      )
                    : Container(),
                description != null
                    ? _paddedDescription(description)
                    : Container(),
                actionButtons != null ? _actionBar() : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizedIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
        ],
      ),
    );
  }

  Widget _paddedTitle(TextSection title) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
        bottom: actionButtons == null || actionButtons.length == 0 ? 15.0 : 0.0,
      ),
      child: title,
    );
  }

  Widget _paddedDescription(TextSection description) {
    // The only difference between paddedTitle and paddedDescription is the top
    // padding.
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 5.0,
        right: 20.0,
        bottom: actionButtons == null || actionButtons.length == 0 ? 15.0 : 0.0,
      ),
      child: description,
    );
  }

  Widget _actionBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 5,
        top: 20.0,
        right: 15,
        bottom: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _customizedActionButtons(),
      ),
    );
  }

  List<Widget> _customizedActionButtons() {
    List<Widget> paddedButtonList = [];

    for (int i = 0; i < actionButtons.length; i++) {
      paddedButtonList.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: actionButtons[i],
        ),
      );
    }

    return paddedButtonList;
  }
}
