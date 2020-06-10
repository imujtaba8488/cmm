part of 'go_family.dart';

class GoLabelledButton extends GoButton {
  final Icon icon;
  final Text label;
  final Function onPressed;
  final EdgeInsets margin, padding;
  final ShapelessResponderDecoration decoration;

  GoLabelledButton({
    this.icon = const Icon(Icons.bluetooth, size: 12.0,),
    @required this.onPressed,
    this.padding,
    this.margin,
    this.decoration,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Responder(
      decoration: decoration,
      child: Row(
        children: <Widget>[
          Container(
            padding: padding ?? const EdgeInsets.all(5.0).copyWith(right: 5.0),
            child: icon?? Container(),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.all(5.0).copyWith(left: 0.0),
            child: label,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
