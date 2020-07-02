import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/basic_dialog.dart';
import '../login/login_dialog.dart';
import '../login/sign_up_form.dart';
import 'avatar.dart';

class SignOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return BasicDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            child: Column(
              children: <Widget>[
                Avatar(),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                appProvider.signOut();
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => LoginDialog(),
                );
              },
              child: Text(
                'Sign Out!',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
