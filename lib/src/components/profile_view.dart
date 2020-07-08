import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import 'edit_profile_dialog.dart';
import '../login/login_dialog.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return InkWell(
          onTap: () => showDialog(

            context: context,
            builder: (context) =>
                appProvider.isSignedIn ? EditProfileDialog() : LoginDialog(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              appProvider.user != null && appProvider.user.imageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(appProvider.user.imageUrl),
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage('assets/test.jpg'),
                    ),
              SizedBox(width: 5.0),
              appProvider.user != null
                  ? Text(
                      '${appProvider.user.firstName} ${appProvider.user.lastName}',
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
