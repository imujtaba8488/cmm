import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingButtonBar extends StatefulWidget {
  final Icon icon;
  final List<FloatingBarButton> actionButtons;
  final Color barColor;
  final bool enableShadow;

  FloatingButtonBar({
    this.icon = const Icon(Icons.share),
    @required this.actionButtons,
    this.barColor,
    this.enableShadow = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _FloatingButtonBarState();
  }
}

class _FloatingButtonBarState extends State<FloatingButtonBar> {
  OverlayEntry overlayEntry;

  // FocusNode is only used to determine the position of Lanuch Button.
  // Review: Perhaps, there is a better way to determine the position.
  FocusNode iconPosDeterminer = FocusNode();

  bool overlayRemoved;

  @override
  void initState() {
    super.initState();
    overlayRemoved = true;
  }

  @override
  Widget build(BuildContext context) {
    // Create overlay
    overlayEntry = OverlayEntry(
      builder: (context) {
        return _FloatBar(
          _removeOverlay,
          iconPosDeterminer,
          widget.actionButtons,
          widget.barColor,
          widget.enableShadow,
        );
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: widget.icon,
          focusNode: iconPosDeterminer,
          onPressed: _insertOverlay,
        ),
      ],
    );
  }

  void _insertOverlay() {
    if (overlayRemoved) {
      Overlay.of(context).insert(overlayEntry);
      overlayRemoved = false;
    }
  }

  void _removeOverlay() {
    setState(() {
      if (!overlayRemoved) {
        overlayEntry.remove();
        overlayRemoved = true;
      }
    });
  }
}

class _FloatBar extends StatefulWidget {
  final Function removeOverlay;
  final FocusNode iconPosDeterminer;
  final List<FloatingBarButton> actionButtons;
  final Color barColor;
  final bool showShadow;

  _FloatBar(
    this.removeOverlay,
    this.iconPosDeterminer,
    this.actionButtons,
    this.barColor,
    this.showShadow,
  );

  @override
  State<StatefulWidget> createState() {
    return _FloatBarState();
  }
}

class _FloatBarState extends State<_FloatBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool iconPosIsRight = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    // Width of the bar depends on number of action buttons it contains.
    animation = Tween(
      begin: 0.0,
      end: 48.0 * widget.actionButtons.length,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInCubic,
      ),
    );

    controller.forward().orCancel;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine, if icon is placed on the right side of the screen.
    iconPosIsRight = widget.iconPosDeterminer.offset.dx >
        MediaQuery.of(context).size.width / 2.0;

    return Stack(
      children: <Widget>[
        Positioned(
          left: iconPosIsRight ? null : 48.0,
          right: iconPosIsRight ? 48.0 : null,
          top: widget.iconPosDeterminer.offset.dy + 0.0,
          child: Container(
            // Width of the bar accepts 6 Buttons at max.
            constraints: BoxConstraints(maxWidth: 48 * 6.0),
            width: animation.value,
            decoration: _barDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _wrappedActionButtons(),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration _barDecoration() {
    return BoxDecoration(
      color: widget.barColor != null ? widget.barColor : Colors.orange,
      boxShadow: widget.showShadow
          ? [
              BoxShadow(
                spreadRadius: 0.5,
                offset: Offset(0.0, 0.5),
                color: Colors.grey,
              )
            ]
          : [],
      borderRadius: BorderRadius.circular(2.0),
    );
  }

  /// Wraps the FloatingBarButton so that in addition to whatever it does, it
  /// also closes the Floatbar, when pressed.
  List<_FloatingBarButtonWrapper> _wrappedActionButtons() {
    // List initialized to an empty list, as this method must not return 'null'.
    List<_FloatingBarButtonWrapper> wrappers = [];

    widget.actionButtons.forEach(
      (actionButton) {
        wrappers.add(
          _FloatingBarButtonWrapper(animation, _closeFloatingBar, actionButton),
        );
      },
    );

    return wrappers;
  }

  void _closeFloatingBar() {
    if (animation.isCompleted) {
      controller.reverse().orCancel.then((value) {
        // Wait for reverse animation to finish.
        widget.removeOverlay();
      });
    }
  }
}

/// A wrapper for the FloatingBarButton, that adds support for closing the Floatbar, when the FloatingBarButton is pressed, in addition to whatever it does on its own.
class _FloatingBarButtonWrapper extends StatelessWidget {
  final Animation animation;
  final Function closeFloatingBar;
  final FloatingBarButton floatingBarButton;

  _FloatingBarButtonWrapper(
    this.animation,
    this.closeFloatingBar,
    this.floatingBarButton,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // In addition to whatever the FloatingBarButton does, also close
            // the Floatbar, when the FloatingBarButton is pressed.
            floatingBarButton.onPressed();
            closeFloatingBar();
          },

          // Prevent layout overflow by not drawing the child until the animation is complete.
          child: animation.isCompleted ? floatingBarButton.icon : Container(),
        ),
      ),
    );
  }
}

class FloatingBarButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  FloatingBarButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Icon size is constant.
      child: Icon(icon.icon, size: 24.0),
      onTap: onPressed,
    );
  }
}
