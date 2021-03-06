import 'package:flutter/material.dart';

import 'app_dialog.dart';

void showToast({
  @required BuildContext context,
  String message = 'Customize Me!',
  Duration duration = const Duration(milliseconds: 1500),
}) {
  showDialog(
    context: context,
    builder: (context) {
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
      return AppDialog(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
          ],
        ),
      );
    },
  );
}

// Todo: Add animations such as fade in and fade out later on!
