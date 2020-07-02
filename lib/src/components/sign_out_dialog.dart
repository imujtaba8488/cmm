import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/basic_dialog.dart';
import '../login/login_dialog.dart';

class SignOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return BasicDialog(
      child: FlatButton(
        onPressed: () {
          appProvider.signOut();
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (context) => LoginDialog(),
          );
        },
        child: Text(
          'Sign Out',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
