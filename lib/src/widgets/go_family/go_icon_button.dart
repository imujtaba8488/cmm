part of 'go_family.dart';

/// A customized Icon Button for GoFamily Widgets.
class GoIconButton extends GoButton {
  final bool autofit;
  final Icon icon;
  final Function onPressed;
  final EdgeInsets margin, padding;
  final ResponderDecoration decoration;

  GoIconButton({
    this.autofit = false,
    @required this.icon,
    @required this.onPressed,
    this.padding,
    this.margin,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Responder(
      child: icon,
      onPressed: onPressed,
      decoration: decoration?.alteredCopy(
              shape: decoration?.shape ?? ResponderShape.circle,
              color: Colors.transparent) ??
          ResponderDecoration(
            shape: ResponderShape.circle,
            border: Border.all(color: Colors.green, width: 0.2),
          ),
    );
  }
}
