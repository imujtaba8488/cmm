import 'package:flutter/material.dart';

import '../widgets/app_dialog.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog>
    with SingleTickerProviderStateMixin {
  int activeTab = 0;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    // ! Good Job Mujtaba: 
    // * Requirement: Change tab index when swiping between tabs.
    // * It seems flutter does not provide anyway listen to the change in index when swiping between tabs, although onTap() for a TabBar only works when a particular tab is tapped. In this scenerio, scroll metrices are used to detect swipe and the height of the dialog is set accordingly. Swiping dispatches scroll notifications which are handled within the NotificationListener and controller index is set as per the scroll past a certain pixel threshold.
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        setState(() {
          if (notification.metrics.pixels <= 100) {
            controller.index = 0;
          } else {
            controller.index = 1;
          }
        });

        return true;
      },
      child: AppDialog(
        child: Container(
          height: controller.index == 0
              ? MediaQuery.of(context).size.height / 2.4
              : MediaQuery.of(context).size.height / 1.8,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                controller: controller,
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
                  controller: controller,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: SignInForm(),
                      ),
                    ),

                    // If a container is not displayed during the tab switch to tab0, renderflex error is thrown because of the height change.
                    controller.index == 0
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
