part of 'go_family.dart';

/// A customized ButtonBar for GoFamily Widgets.
class GoButtonBar extends StatelessWidget {
  final double height;
  final EdgeInsets padding, margin;
  final BoxDecoration decoration;
  final List<GoButton> buttons;

  GoButtonBar({
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.buttons = const <GoIconButton>[],
  }) {
    assert(buttons != null);
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultBGColor = Colors.grey.shade600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height ?? PercentOf(constraints.maxWidth).percent(10),
          decoration: decoration?.copyWith(
                color: decoration?.color ?? defaultBGColor,
              ) ??
              BoxDecoration(color: defaultBGColor),
          margin: margin,
          padding: padding,
          child: buttons.length > 0
              ? FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: buttons,
                  ),
                )
              : Container(),
        );
      },
    );
  }

  Widget alteredCopy({
    double height,
    EdgeInsets padding,
    EdgeInsets margin,
    final BoxDecoration decoration,
    final List<GoIconButton> buttons,
  }) =>
      GoButtonBar(
        height: height ?? this.height,
        margin: margin ?? this.margin,
        padding: padding ?? this.padding,
        decoration: decoration ?? this.decoration,
        buttons: buttons ?? this.buttons,
      );

  // Widget copyWithModifiedIconSettings({IconSettings iconSettings}) {
  //   List<GoIconButton> modifiedButtons = [];

  //   buttons.forEach((button) {
  //     modifiedButtons.add(
  //       GoIconButton(
  //         icon: Icon(
  //           button.icon.icon,
  //           color: iconSettings?.color ?? button.icon.color,
  //           size: iconSettings?.size ?? button.icon.color,
  //         ),
  //         margin: button.margin,
  //         padding: button.padding,
  //         onPressed: button.onPressed,
  //       ),
  //     );
  //   });

  //   return GoButtonBar(
  //     height: this.height,
  //     decoration: this.decoration,
  //     margin: this.margin,
  //     padding: this.padding,
  //     buttons: modifiedButtons,
  //   );
  // }
}

abstract class GoButton extends StatelessWidget {}

class GoButtonSpacer extends GoButton {
  final double space;

  GoButtonSpacer({this.space = 2.0}) {
    assert(space >= 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: space);
  }
}