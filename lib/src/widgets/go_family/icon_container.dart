part of 'go_family.dart';

class AutoFit extends StatelessWidget {
  final bool autofit;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final Widget child;

  AutoFit({
    this.autofit = true,
    this.margin,
    this.padding,
    this.decoration,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return autofit
        ? FittedBox(
            child: Container(
              decoration: decoration,
              margin: margin,
              padding: padding,
              child: child,
            ),
          )
        : Container(
          decoration: decoration,
            margin: margin,
            padding: padding,
            child: child,
          );
  }

  AutoFit alteredCopy({
    bool autofit = false,
    EdgeInsets margin,
    EdgeInsets padding,
    BoxDecoration decoration,
    Icon child,
  }) {
    return AutoFit(
      autofit: autofit ?? this.autofit,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      child: child ?? this.child,
    );
  }
}
