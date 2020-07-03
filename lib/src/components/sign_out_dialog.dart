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
  bool isEditable;
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
    isEditable = false;
    firstName = lastName = password = newPassword = confirmNewPassword = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        firstNameController.text = appProvider.user?.firstName;
        lastNameController.text = appProvider.user?.lastName;

        return BasicDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      isEditable ? 'Save Profile' : 'Edit Profile',
                      style: TextStyle(
                        color: isEditable ? Colors.grey[600] : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Avatar(
                            networkImage: appProvider.user?.imageUrl,
                            isSelectionEnabled: isEditable,
                          ),
                          Text(
                            '${appProvider.user?.firstName}${appProvider.user?.lastName}',
                            style: TextStyle(
                              color:
                                  isEditable ? Colors.white : Colors.grey[500],
                            ),
                          ),
                          CustomButton(
                            child: isEditable ? Text('Save') : Text('Edit'),
                            icon: isEditable
                                ? Icon(Icons.save)
                                : Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditable = !isEditable;
                              });
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
                            enabled: isEditable,
                            controller: firstNameController,
                            onSaved: (String value) => firstName = value,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: CustomTextFormField(
                            label: 'Last Name',
                            enabled: isEditable,
                            controller: lastNameController,
                            onSaved: (String value) => lastName = value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    CustomTextFormField(
                      label: 'Password',
                      enabled: isEditable,
                      onSaved: (String value) => password = value,
                    ),
                    SizedBox(height: 5.0),
                    CustomTextFormField(
                      label: 'New Password',
                      enabled: isEditable,
                      onSaved: (String value) => newPassword = value,
                      controller: newPasswordController,
                    ),
                    SizedBox(height: 5.0),
                    CustomTextFormField(
                      label: 'Confirm New Password',
                      enabled: isEditable,
                      onSaved: (String value) => confirmNewPassword = value,
                      controller: confirmNewPasswordController,
                      validator: (value) {
                        if (value.contains(newPasswordController.text) &&
                            value.length == newPasswordController.text.length) {
                          return null;
                        } else {
                          return 'New and Confirm Password do not match';
                        }
                      },
                    ),
                    isEditable ? Container() : SizedBox(height: 10.0),
                  ],
                ),
              ),
              isEditable
                  ? Container()
                  : Divider(
                      color: Colors.white,
                      height: 1.0,
                    ),
              isEditable
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
        );
      },
    );
  }

  void onSaved() {
    if (_formKey.currentState.validate()) {
      isEditable = false;
      _formKey.currentState.save();
    } else {
      isEditable = true;
    }
  }
}
