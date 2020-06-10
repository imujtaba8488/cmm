import 'package:flutter/material.dart';

/// FoldableContainer is simply a Container which supports folding and
/// unfolding.
///
/// Normally, during the build of this widget, if [requestFold] is set to true,
/// the FoldableContainer folds and vice-versa.
///
/// Folding and unfolding can be controlled using a trigger in the parent
/// widget, only if parent forces the child i.e. this widget, to rebuild with a
/// different value for [requestFold]. Hence, the parent has to be a
/// Statefulwidget. It is the responsiblity of the implementer (widget-user) to
/// use a StatefulWidget and rebuild the FoldableContainer widget with the
/// proper value for [requestFold], when it is required to control the folding &
/// unfolding using a trigger in the parent widget.
///
/// __Note__: By default the FoldableContainer has a backgroundColor of
/// Colors.grey.shade200, but if the  child widget is given a backgroundColor,
/// it takes precedence over the default backgroundColor of the Foldable
/// Container. 
///
/// <| ENCHANCE || OBSERVATION |>
/// A background message can be added while the container is folding or
/// unfolding. Though, it's also possible to add a separate widget in the
/// background however, that may cause the same renderflex overflow error.
///
/// <| RENAMABLE CANDIDATES |> ~ Candidates with which to be renamed ~
/// Foldable, Collapsable, Closeable, Expandable,
class FoldableContainer extends StatefulWidget {
  final Widget child;
  final bool requestFold;
  final Duration duration;
  final BoxDecoration decoration;
  final EdgeInsets margin, padding;

  FoldableContainer({
    this.requestFold = false,
    this.duration = const Duration(milliseconds: 200),
    this.decoration,
    this.margin,
    this.padding,
    @required this.child,
  });

  @override
  State<StatefulWidget> createState() => FoldableContainerState();
}

class FoldableContainerState extends State<FoldableContainer>
    with SingleTickerProviderStateMixin {
  //...
  AnimationController controller;
  Animation animation;

  // Height of the container after the child widget is completely rendered.
  double heightPostRendering;
  bool isChildHidden = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));

    //  <|IMPORTANT|>
    // Calls _afterLayout once the child widget has been completely rendered.
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FoldableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // <|IMPORTANT|>
    // Take action based on the value of requestFold, when parent rebuilds.
    widget.requestFold ? _animate() : _animate(fold: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Child Widget's backgroundColor takes precedence over this color.
      // When decoration is null value of color is used. However, if the
      // decoration is not null, and it doesn't provide the color value, default
      // color is used.
      decoration: widget.decoration?.copyWith(
        color: widget.decoration?.color ?? Colors.grey.shade200,
      ),
      color: widget.decoration == null ? Colors.grey.shade200 : null,
      margin: widget.margin,
      padding: widget.padding,
      height: animation?.value,
      child: isChildHidden ? Container() : widget.child,
    );
  }

  /// Folds or unfolds the container based on the value of [fold].
  void _animate({bool fold = true}) {
    //...
    animation = Tween(
      begin: fold ? heightPostRendering : 0.0,
      end: fold ? 0.0 : heightPostRendering,
    ).animate(controller);

    // To avoid rendeflex overflow error, child hidden before the animation begins.
    setState(() => isChildHidden = true);

    controller.reset();

    // To avoid renderflex overflow error, child revealed after the animation finishes.
    controller.forward().then((f) => isChildHidden = false);
  }

  /// Returns height of container once the child widget is completely rendered.
  _afterLayout(_) {
    //..
    print(':: _afterLayout :: ${context.size}');

    heightPostRendering = context.size.height;
  }
}
      