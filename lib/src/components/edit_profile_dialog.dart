import 'package:cmm/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/app_dialog.dart';
import '../login/login_dialog.dart';
import '../avatar_picker/avatar.dart';
import 'custom_button.dart';
import '../login/custom_text_form_field.dart';
import '../widgets/toast.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isInEditMode;

  TextEditingController _firstNameController,
      _lastNameController,
      _passwordController,
      _newPasswordController,
      _confirmNewPasswordController;
  String _firstName, _lastName, _newPassword;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
    _isInEditMode = false;
    _firstName = _lastName = _newPassword = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        _firstNameController.text = appProvider.user?.firstName;
        _lastNameController.text = appProvider.user?.lastName;

        return AppDialog(
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
                            SizedBox(width: 5.0),
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  '${appProvider.user?.firstName} ${appProvider.user?.lastName}',
                                  style: TextStyle(
                                    color: _isInEditMode
                                        ? Colors.white
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                            CustomButton(
                              child:
                                  _isInEditMode ? Text('Save') : Text('Edit'),
                              icon: _isInEditMode
                                  ? Icon(Icons.save)
                                  : Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isInEditMode = !_isInEditMode;
                                });

                                // onSaved() only needs to be called when user taps on save and not on edit.
                                if (!_isInEditMode) {
                                  _onSaved();
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
                              controller: _firstNameController,
                              onSaved: (String value) =>
                                  _firstName = value.trim(),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Last Name',
                              enabled: _isInEditMode,
                              controller: _lastNameController,
                              onSaved: (String value) =>
                                  _lastName = value.trim(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Password',
                        enabled: _isInEditMode,
                        validator: _passwordValidator,
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'New Password',
                        enabled: _isInEditMode,
                        onSaved: (String value) => _newPassword = value.trim(),
                        controller: _newPasswordController,
                        obscureText: true,
                        validator: _newPasswordValidator,
                      ),
                      SizedBox(height: 8.0),
                      CustomTextFormField(
                        label: 'Confirm New Password',
                        enabled: _isInEditMode,
                        controller: _confirmNewPasswordController,
                        validator: _confirmNewPasswordValidator,
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

  void _onSaved() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.pop(context);

      if (_newPasswordController.text.isNotEmpty &&
          _confirmNewPasswordController.text.isNotEmpty) {
        User user = User(
          firstName: _firstName,
          lastName: _lastName,
          password:
              _newPassword.isEmpty ? appProvider.user.password : _newPassword,
          email: appProvider.user.email,
          currency: appProvider.user.currency,
          imageUrl: appProvider.user.imageUrl,
          id: appProvider.user.id,
          lowBalanceThreshold: appProvider.user.lowBalanceThreshold,
        );

        appProvider.updateUser(user);

        showToast(context: context, message: 'Profile Updated!');
      }
    } else {
      // In case of an error do not exit the edit mode.
      setState(() {
        _isInEditMode = true;
      });
    }
  }

  String _passwordValidator(String value) {
    if (value.isEmpty) {
      return null;
    } else if (_isPasswordCorrect(value)) {
      return null;
    } else {
      return 'Incorrect Password!';
    }
  }

  String _newPasswordValidator(String value) {
    print(value);
    if (value.length > 0 && value.length < 6) {
      return 'Password must be 6 characters long.';
    } else {
      return null;
    }
  }

  String _confirmNewPasswordValidator(String value) {
    if (value.isEmpty &&
        _newPasswordController.text.isEmpty &&
        _confirmNewPasswordController.text.isEmpty) {
      return null;
    } else if (value.contains(_newPasswordController.text) &&
        value.length == _newPasswordController.text.length &&
        _isPasswordCorrect(_passwordController.text)) {
      return null;
    } else if (value.contains(_newPasswordController.text) &&
        value.length == _newPasswordController.text.length &&
        _passwordController.text.isEmpty) {
      return 'Password cannot be empty.';
    } else {
      return 'New and Confirm New Passwords do not match.';
    }
  }

  bool _isPasswordCorrect(String value) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return appProvider.user.password.length == value.length &&
        appProvider.user.password.contains(value);
  }
}
