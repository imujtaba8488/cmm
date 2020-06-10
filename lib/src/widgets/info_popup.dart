import 'package:flutter/material.dart';

class InfoPopupMenu extends StatefulWidget {
  final Icon icon;
  final String text;
  final Size size;

  InfoPopupMenu({
    this.icon,
    this.text = 'Your information will appear here',
    this.size = const Size(200.0, 200.0),
  });

  @override
  State<StatefulWidget> createState() {
    return _InfoPopupMenuState();
  }
}

class _InfoPopupMenuState extends State<InfoPopupMenu> {
  OverlayEntry popupOverlay;
  FocusNode menuFocusNode = FocusNode();
  bool popupRemoved = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!popupRemoved) {
          popupOverlay.remove();
          popupRemoved = true;
        }
      },
      child: IconButton(
        icon: widget.icon != null ? widget.icon : Icon(Icons.menu),
        onPressed: _onPopupIconPressed,
        focusNode: menuFocusNode,
      ),
    );
  }

  void _onPopupIconPressed() {
    if (popupRemoved) {
      Overlay.of(context).insert(
        popupOverlay = OverlayEntry(
          builder: (context) {
            return _InfoPopup(
              popupOverlay,
              menuFocusNode,
              _updatePopupRemoved,
              widget.text,
              widget.size,
            );
          },
        ),
      );

      popupRemoved = false;
    }
  }

  void _updatePopupRemoved(bool removed) {
    popupRemoved = removed;
  }
}

class _InfoPopup extends StatefulWidget {
  final OverlayEntry popupOverlayEntry;
  final FocusNode popupFocusNode;
  final Function updatePopupRemoved;
  final String text;
  final Size size;

  _InfoPopup(
    this.popupOverlayEntry,
    this.popupFocusNode,
    this.updatePopupRemoved,
    this.text,
    this.size,
  );

  @override
  State<StatefulWidget> createState() {
    return _InfoPopupState();
  }
}

class _InfoPopupState extends State<_InfoPopup>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation blowAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    blowAnimation = Tween(begin: 0.0, end: 150.0).animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double xOffset = widget.popupFocusNode.offset.dx + 5.0;
    double yOffset = widget.popupFocusNode.offset.dy + 5.0;

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    print('DEVICE WIDTH: $deviceWidth'); // temp
    print('XOFFSET: $xOffset'); // temp

    return Stack(
      children: <Widget>[
        Positioned(
          // Observe: This part is very very important. Explain it in detail later.
          left: xOffset < deviceWidth / 2.0 ? xOffset : null,
          right: xOffset > deviceWidth / 2.0
              ? deviceWidth - (xOffset + 35.0)
              : null,
          top: yOffset < deviceHeight / 2.0 ? yOffset : null,
          bottom: yOffset > deviceHeight / 2.0
              ? deviceHeight - (yOffset + 35.0)
              : null,
          child: _overlayBackground(),
        )
      ],
    );
  }

  Widget _overlayBackground() {
    return GestureDetector(
      onTap: () {
        widget.popupOverlayEntry.remove();
        widget.updatePopupRemoved(true);
      },
      child: Container(
        height: blowAnimation.value,
        width: blowAnimation.value,
        child: Material(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.0),
          child: blowAnimation.isCompleted
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
