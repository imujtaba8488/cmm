import 'package:flutter/material.dart';

/// The 'Overrides' 
class TextSection extends StatelessWidget {
  final List<TextEntry> textEntries;
  final int maxLines;
  final TextAlign textAlign;

  //... 'Overrides' --> overrides the individual styles of TextEntries, hence,
  //... providing a uniform style for the entire section.
  final double fontSizeOverride;
  final Color colorOverride;
  final String fontFamilyOverride;
  final FontWeight fontWeightOverrride;
  final double letterSpacingOverride;
  final double wordSpacingOverride;

  TextSection({
    this.textEntries,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.fontSizeOverride,
    this.colorOverride,
    this.fontFamilyOverride,
    this.fontWeightOverrride,
    this.letterSpacingOverride,
    this.wordSpacingOverride,
  }) {
    assert(textEntries != null);
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      textAlign: textAlign,
      text: TextSpan(
        children: _customizedTextSpans(),
      ),
    );
  }

  List<TextSpan> _customizedTextSpans() {
    List<TextSpan> textSpans = [];

    textEntries.forEach(
      (textEntry) {
        textSpans.add(
          TextSpan(
            text: textEntry.text,
            style: textEntry.style.copyWith(
              fontSize: fontSizeOverride ?? fontSizeOverride,
              color: colorOverride ?? colorOverride,
              fontFamily: fontFamilyOverride ?? fontFamilyOverride,
              fontWeight: fontWeightOverrride ?? fontWeightOverrride,
              letterSpacing: letterSpacingOverride ?? letterSpacingOverride,
              wordSpacing: wordSpacingOverride ?? wordSpacingOverride,
            ),
          ),
        );
      },
    );

    return textSpans;
  }
}

class TextEntry extends StatelessWidget {
  final String text;
  final Color color;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final double wordSpacing;
  final double letterSpacing;

  TextEntry(
    this.text, {
    this.color = Colors.black,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.wordSpacing,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }

  TextStyle get style {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      wordSpacing: wordSpacing,
      letterSpacing: letterSpacing,
    );
  }
}
