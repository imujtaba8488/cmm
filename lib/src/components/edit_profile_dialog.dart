import 'dart:async';

import 'package:cmm/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/basic_dialog.dart';
import '../login/login_dialog.dart';
import '../avatar_picker/avatar.dart';
import 'custom_button.dart';
import '../login/custom_text_form_field.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isInEditMode;
  bool _isAnError;

  TextEditingController firstNameController,
      lastNameController,
      passwordController,
      newPasswordController,
      confirmNewPasswordController;
  String firstName, lastName, password, newPassword, confirmNewPassword;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    _isInEditMode = false;
    _isAnError = false;
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
                        _isInEditMode ? 'Save Profile' : 'Edit Profile',
                        style: TextStyle(
                          color:
                              _isInEditMode ? Colors.grey[600] : Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Avatar(
                              networkImage: appProvider.user?.imageUrl,
                              isSelectionEnabled: _isInEditMode,
                            ),
                            Text(
                              '${appProvider.user?.firstName}${appProvider.user?.lastName}',
                              style: TextStyle(
                                color: _isInEditMode
                                    ? Colors.white
                                    : Colors.grey[500],
                              ),
                            ),
                            CustomButton(
                              child:
                                  _isInEditMode ? Text('Save') : Text('Edit'),
                              icon: _isInEditMode
                                  ? Icon(Icons.save)
                                  : Icon(Icons.edit),
                              onPressed: () {
                                onSaved();

                                if (!_isAnError) {
                                  setState(() {
                                    _isInEditMode = !_isInEditMode;
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
                              enabled: _isInEditMode,
                              controller: firstNameController,
                              onSaved: (String value) => firstName = value,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Last Name',
                              enabled: _isInEditMode,
                              controller: lastNameController,
                              onSaved: (String value) => lastName = value,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Password',
                        enabled: _isInEditMode,
                        onSaved: (String value) => password = value,
                        validator: (String value) {
                          if (!value.contains(appProvider.user.password) &&
                              value.length > 0) {
                            return 'Incorrect Password!';
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'New Password',
                        enabled: _isInEditMode,
                        onSaved: (String value) => newPassword = value,
                        controller: newPasswordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Confirm New Password',
                        enabled: _isInEditMode,
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
                        obscureText: true,
                      ),
                      _isInEditMode ? Container() : SizedBox(height: 10.0),
                    ],
                  ),
                ),
                _isInEditMode
                    ? Container()
                    : Divider(
                        color: Colors.white,
                        height: 1.0,
                      ),
                _isInEditMode
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isAnError = false;
      });

      User user = User(
        firstName: firstName,
        lastName: lastName,
        password: newPassword.isEmpty ? appProvider.user.password : newPassword,
        email: appProvider.user.email,
        currency: appProvider.user.currency,
        imageUrl: appProvider.user.imageUrl,
        id: appProvider.user.id,
        lowBalanceThreshold: appProvider.user.lowBalanceThreshold,
      );

      appProvider.updateUser(user);

      passwordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context);
            });
            return BasicDialog(
              child: Text('Password Updated!'),
            );
          });
    } else {
      setState(() {
        _isAnError = true;
      });
    }
  }
}
