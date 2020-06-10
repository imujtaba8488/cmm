// ::: Under Consideration :::

/// ::-> Requirement <-::
/// Its almost usual to compose a tree of standard Flutter Widgets together to
/// create a 'Custom Widget'. Now, when creating the custom widget, you may want
/// the user to provide one of such widgets, hence accept it as an argument.
/// For example, lets say you are creating a custom ListTile widget. Some of the
/// standard Flutter Widgets you may use to create a custom ListTile Widget would
/// include Text, Icon, etc.
///
/// Let's say your class accepts a Text widget to display the text in the custom
/// ListTile, however, you want the TextAlign and the fontSize property of the
/// textField to stay fixed, hence not customizable by the widget user.
///
/// One way to achieve this is to wrap the user provided Text widget into an
/// internal Text widget to keep the above properties fixed. So, you wrap the
/// user text widget into your own Text Widget and just alter the properties you
/// want to stay fixed. But wait, is there a way to modify only certain properites
/// of a Text widget without affecting the other user customized properties?
///
/// Well the answer is yes and no. For fontSize it can be done, since the TextStyle
/// provides apply() or copyWith() methods. But what about the TextAlign property
/// or the other ones, there seems to be no direct way to do it.
///
/// For widgets having limited number of properites, probably its easy to use a
/// conditional to do that, but consider a gigantic widgets with say 50 properties,
/// would it make sense to use a conditional (eg: if this then that or this) or
/// rather have an interface, where the would be able to just modify the properites 
/// you want, without touching the rest of them.
///
/// One way is given below, probably may consider this, after I conclude my
/// research that there could be situations like this and there is technically
/// no other way to do it.

import 'package:flutter/material.dart';

class WText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign textAlign;

  WText(this.data, {this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: textAlign,
    );
  }

  Text alter({String d, TextStyle s, TextAlign a}) {
    return Text(
      d == null ? data : d,
      style: s == null ? style : s,
      textAlign: a == null ? textAlign : a,
    );
  }
}