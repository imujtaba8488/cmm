import 'package:flutter/material.dart';

class Tap extends StatefulWidget {
  final bool start;
  final Widget child;

  Tap({this.start = false, this.child});

  @override
  State<StatefulWidget> createState() {
    return TapState();
  }
}

class TapState extends State<Tap> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation, widthAnimation;
  double heightPostRendering, widthPostRendering, center;
  BoxDecoration decoration, defaultDecoration;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });

    defaultDecoration = BoxDecoration(
      color: Colors.black,
      // shape: BoxShape.circle,
    );

    decoration = defaultDecoration;

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _animate,
      child: Container(
        padding: EdgeInsets.all(5.0),
        // decoration: decoration,
        height: animation?.value,
        width: widthAnimation?.value,
        child: controller.isAnimating ? Container() : widget.child,
      ),
    );
  }

  void _animate() {
    // print('height post rendering: $heightPostRendering');  // temp:

    animation = Tween(
      begin: 0.0,
      end: heightPostRendering,
    ).animate(controller);

    widthAnimation = Tween(
      begin: 0.0,
      end: widthPostRendering,
    ).animate(controller);

    controller.reset();
    controller.forward().then((f) {
      decoration = defaultDecoration;
    });

    decoration = BoxDecoration(
      color: Colors.red,
      // shape: BoxShape.circle,
    );

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  _afterLayout(_) {
    heightPostRendering = context.size.height;
    widthPostRendering = context.size.width;

    print('height: $heightPostRendering');
    print('width: $widthPostRendering');
  }
}
