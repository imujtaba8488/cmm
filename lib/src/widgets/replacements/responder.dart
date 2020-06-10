part of 'replacements.dart';

/// A responder is simply a custom 'Container' which makes it's child 
/// responsive, i.e. a widget placed within the responder can respond to 
/// gestures such as taps, double-taps etc. alongwith displaying the related 
/// effects while controlling the underlying complexity.
///
/// Another way of saying it is that 'responder' is a superset of container 
/// which adds the gesturing capability to its child.
///
/// Review: How about naming it ResponseAware instead of Responder, since it 
/// makes its child aware of the taps etc. or may be ... ActAware, GestureAware,
/// TapAware, etc. More suggestions??? 
///
class Responder extends StatelessWidget {
  /// Defines what should happen when the child widget is pressed.
  final Function onPressed;

  /// Color to splash when the child widget is tapped.
  final Color splashColor;

  /// Defines the decoration of the Gesturer.
  final ResponderDecoration decoration;

  final Widget child;
 
  Responder({
    this.onPressed,
    this.splashColor,
    this.decoration,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Without the Material InkWell is hidden.
    return Material(
      color: decoration?.color ?? Colors.grey,
      shape: decoration?.shape == ResponderShape.circle
          ? CircleBorder(
              side: decoration?.border?.left ?? BorderSide.none,
            )
          : RoundedRectangleBorder(
              side: decoration?.border?.left ?? BorderSide.none,
            ),
      borderRadius: decoration?.borderRadius,
      elevation: decoration?.elevation ?? 0.0,
      child: InkWell(
        borderRadius: decoration?.shape == ResponderShape.circle
            ? BorderRadius.circular(5000)
            : null,
        splashColor: splashColor,
        onTap: onPressed,

        // Review: Error when incoming width constraints are unbound!
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              // Color must be transparent to avoid hiding the InkWell.
              color: Colors.transparent,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Determines the shape of the Gesturer.
enum ResponderShape {
  square,
  circle,
  rectangle,
  star,
  oval,
  hexagon,
}

class ResponderDecoration {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final double elevation;
  final Border border;
  final ResponderShape shape;
  final Color splashColor;
  final BoxShadow shadow;

  ResponderDecoration({
    this.color = Colors.transparent,
    this.borderRadius,
    this.elevation,
    this.border,
    this.shape = ResponderShape.rectangle,
    this.splashColor,
    this.shadow,
  });

  ResponderDecoration alteredCopy({
    Color color = Colors.transparent,
    BorderRadiusGeometry borderRadius,
    double elevation,
    BoxBorder border,
    ResponderShape shape,
    Color splashColor,
    BoxShadow shadow,
  }) =>
      ResponderDecoration(
        color: color ?? this.color,
        borderRadius: borderRadius ?? this.borderRadius,
        elevation: elevation ?? this.elevation,
        border: border ?? this.border,
        shape: shape ?? this.shape,
        splashColor: splashColor ?? this.splashColor,
        shadow: shadow ?? this.shadow,
      );
}

class ShapelessResponderDecoration extends ResponderDecoration {
  ShapelessResponderDecoration({
    Color color = Colors.transparent,
    BorderRadiusGeometry borderRadius,
    double elevation,
    Border border,
    Color splashColor,
    BoxShadow shadow,
  }) : super(
          color: color,
          borderRadius: borderRadius,
          elevation: elevation,
          border: border,
          splashColor: splashColor,
          shadow: shadow,
        );
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
/// enum ButtonShape {
//   square,
//   circle,
// }

// /// Observe: You can use '..' operator with 'return ButtonContainerState'.
// class ButtonContainer extends StatefulWidget {
//   final Widget child;
//   final Function onPressed;
//   final ButtonShape shape;
//   final ButtonDecoration decoration;
//   final EdgeInsets margin, padding;

//   ButtonContainer({
//     @required this.child,
//     this.onPressed,
//     this.shape = ButtonShape.square,
//     this.decoration,
//     this.margin,
//     this.padding,
//   }) {
//     assert(shape != null);
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return _ButtonContainerState();
//   }
// }

// class _ButtonContainerState extends State<ButtonContainer> {
//   BoxDecoration defaultDecoration, onTapDecoration, decoration;

//   @override
//   void initState() {
//     super.initState();

//     defaultDecoration = BoxDecoration(
//       color: widget?.decoration?.color ?? Colors.green,
//       boxShadow: [
//         BoxShadow(
//           color: widget?.decoration?.shadowColor ?? Colors.black,
//           spreadRadius: 0.0,
//           // offset: Offset(0.0, 0.5),
//         )
//       ],
//       shape: widget.shape == ButtonShape.square
//           ? BoxShape.rectangle
//           : BoxShape.circle,
//       borderRadius: widget?.decoration?.borderRadius,
//       border: widget?.decoration?.border,
//     );

//     onTapDecoration = defaultDecoration.copyWith(boxShadow: []);

//     decoration = defaultDecoration;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onPressed,
//       onTapDown: onTapDown,
//       onTapUp: onTapUp,
//       onTapCancel: onTapCancel,
//       child: Container(
//         margin: widget.margin,
//         padding: widget.padding,
//         decoration: decoration,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(child: widget.child),
//         ),
//       ),
//     );
//   }

//   void onTapDown(TapDownDetails tapDownDetails) {
//     setState(() {
//       decoration = onTapDecoration;
//     });
//   }

//   void onTapUp(TapUpDetails tapUpDetails) {
//     setState(() {
//       decoration = defaultDecoration;
//     });
//   }

//   void onTapCancel() {
//     setState(() {
//       decoration = defaultDecoration;
//     });
//   }

//   void onTap() {
//     setState(() {
//       decoration = null;
//     });
//   }
// }

// class ButtonDecoration {
//   final Color color;
//   final shadowColor;
//   final BoxBorder border;
//   final BorderRadiusGeometry borderRadius;

//   ButtonDecoration({
//     this.color,
//     this.shadowColor,
//     this.border,
//     this.borderRadius,
//   });
// }
