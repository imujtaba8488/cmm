import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/basic_dialog.dart';
import '../login/login_dialog.dart';
import '../avatar_picker/avatar.dart';
import 'custom_button.dart';
import '../login/custom_text_form_field.dart';

class SignOutDialog extends StatefulWidget {
  @override
  _SignOutDialogState createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isInEditMode;
  bool isAnError;
  TextEditingController firstNameController,
      lastNameController,
      newPasswordController,
      confirmNewPasswordController;
  String firstName, lastName, password, newPassword, confirmNewPassword;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    isInEditMode = false;
    isAnError = false;
    firstName = lastName = password = newPassword = confirmNewPassword = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        firstNameController.text = appProvider.user?.firstName;
        lastNameController.text = appProvider.user?.lastName;

        return BasicDialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        isInEditMode ? 'Save Profile' : 'Edit Profile',
                        style: TextStyle(
                          color: isInEditMode ? Colors.grey[600] : Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Avatar(
                              networkImage: appProvider.user?.imageUrl,
                              isSelectionEnabled: isInEditMode,
                            ),
                            Text(
                              '${appProvider.user?.firstName}${appProvider.user?.lastName}',
                              style: TextStyle(
                                color: isInEditMode
                                    ? Colors.white
                                    : Colors.grey[500],
                              ),
                            ),
                            CustomButton(
                              child: isInEditMode ? Text('Save') : Text('Edit'),
                              icon: isInEditMode
                                  ? Icon(Icons.save)
                                  : Icon(Icons.edit),
                              onPressed: () {
                                onSaved();

                                if (!isAnError) {
                                  setState(() {
                                    isInEditMode = !isInEditMode;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomTextFormField(
                              label: 'First Name',
                              enabled: isInEditMode,
                              controller: firstNameController,
                              onSaved: (String value) => firstName = value,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Last Name',
                              enabled: isInEditMode,
                              controller: lastNameController,
                              onSaved: (String value) => lastName = value,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Password',
                        enabled: isInEditMode,
                        onSaved: (String value) => password = value,
                        validator: (String value) {
                          if (!value.contains(appProvider.user.password) &&
                              value.length > 0) {
                            return 'Incorrect Password!';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'New Password',
                        enabled: isInEditMode,
                        onSaved: (String value) => newPassword = value,
                        controller: newPasswordController,
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Confirm New Password',
                        enabled: isInEditMode,
                        onSaved: (String value) => confirmNewPassword = value,
                        controller: confirmNewPasswordController,
                        validator: (value) {
                          if (value.contains(newPasswordController.text) &&
                              value.length ==
                                  newPasswordController.text.length) {
                            return null;
                          } else if (newPasswordController.text.length > 0 &&
                              value.isEmpty) {
                            return '* Required';
                          } else {
                            return 'New and Confirm Password do not match';
                          }
                        },
                      ),
                      isInEditMode ? Container() : SizedBox(height: 10.0),
                    ],
                  ),
                ),
                isInEditMode
                    ? Container()
                    : Divider(
                        color: Colors.white,
                        height: 1.0,
                      ),
                isInEditMode
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
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
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onSaved() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isAnError = false;
      });
    } else {
      setState(() {
        isAnError = true;
      });
    }
  }
}
