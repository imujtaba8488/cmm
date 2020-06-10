part of 'go_family.dart';

/// A customized titled button bar for GoFamily Widgets.
class GoTitledBar extends StatelessWidget {
  final double height;
  final AutoFit leadingIcon;
  final Text title;
  final EdgeInsets padding, margin;
  final BoxDecoration decoration;
  final GoButtonBar buttonBar;
  final Color _defaultBGColor = Colors.grey.shade600;

  GoTitledBar({
    this.height,
    this.leadingIcon,
    @required this.title,
    this.padding = const EdgeInsets.all(5.0),
    this.margin = const EdgeInsets.all(0.0),
    this.decoration,
    this.buttonBar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          // When no backgroundColor is provided, use defaultBGColor.
          decoration: decoration?.copyWith(
            color: decoration?.color ?? _defaultBGColor,
          ),
          color: decoration == null ? _defaultBGColor : null,
          margin: margin,
          padding: padding,

          // Height is 10% of width of the bar.
          height: height ?? PercentOf(constraints.maxWidth).percent(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    leadingIcon != null
                        ? FittedBox(
                            child: leadingIcon.alteredCopy(
                              padding: EdgeInsets.all(5.0),
                            ),
                          )
                        : Container(),
                    FittedBox(child: title),
                  ],
                ),
              ),

              /// When no backgroundColor is provided, use Transparent color.
              buttonBar.alteredCopy(
                decoration: buttonBar?.decoration?.copyWith(
                      color: buttonBar?.decoration?.color ?? Colors.transparent,
                    ) ??
                    BoxDecoration(color: Colors.transparent),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Returns a copy of this GoTitledBar, with the specific properties altered.
  GoTitledBar alteredCopy({
    double height,
    AutoFit leadingIcon,
    Text title,
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    Color buttonBarBackgroundColor,
    BoxDecoration decoration,
    GoButtonBar buttonBar,
  }) =>
      GoTitledBar(
        height: height ?? this.height,
        leadingIcon: leadingIcon ?? this.leadingIcon,
        title: title ?? this.title,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        decoration: decoration ?? this.decoration,
        buttonBar: buttonBar ?? this.buttonBar,
      );
}
