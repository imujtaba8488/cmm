import 'package:flutter/material.dart';

import '../widgets/basic_dialog.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BasicDialog(
        child: Container(
          height: activeTab == 0
              ? MediaQuery.of(context).size.height / 2.7
              : MediaQuery.of(context).size.height / 1.8,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                onTap: (value) {
                  setState(() {
                    activeTab = value;
                  });
                },
                tabs: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Sign In'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Sign up'),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SignInForm(),
                    ),

                    // If a container is not displayed during the tab switch to tab0, renderflex error is thrown because of the height change.
                    activeTab == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: SignUpForm(),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
