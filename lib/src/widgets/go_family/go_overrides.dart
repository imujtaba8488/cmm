part of 'go_family.dart';

class DecorationOverride {
  final double height;
  final BoxDecoration decoration;
  final TextStyle textStyle;
  final IconSettings iconSettings;

  DecorationOverride({
    this.height,
    this.decoration,
    this.textStyle,
    this.iconSettings,
  });
}

class IconSettings {
  final double size;
  final Color color;

  IconSettings({this.size, this.color});
}
