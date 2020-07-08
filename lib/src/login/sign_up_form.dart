import 'dart:io';

import 'package:cmm/src/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:im_avatar/im_avatar.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/toast.dart';
import 'custom_text_form_field.dart';

class SignUpForm extends StatefulWidget {
  final bool enabled;

  SignUpForm({this.enabled = true});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _signUpFormKey = GlobalKey();

  String _firstName, _lastName, _email, _password;

  String imagePath;

  File imagefile;

  bool isSigningUp;

  @override
  void initState() {
    super.initState();

    _firstName = _lastName = _email = _password = '';

    imagePath = 'assets/test.jpg';

    isSigningUp = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          Avatar(
            onSelection: (url, file) {
              imagefile = file;
            },
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    label: 'First Name',
                    onSaved: (value) => _firstName = value,
                    enabled: widget.enabled,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    label: 'Last Name',
                    onSaved: (value) => _lastName = value,
                    enabled: widget.enabled,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              label: 'Email',
              suffixIcon: Icon(
                Icons.email,
                color: Colors.green,
              ),
              onSaved: (value) => _email = value.trim(),
              validator: _emailValidator,
              enabled: widget.enabled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              label: 'Password',
              suffixIcon: Icon(
                Icons.lock,
                color: Colors.green,
              ),
              onSaved: (value) => _password = value.trim(),
              validator: _passwordValidator,
              enabled: widget.enabled,
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                isSigningUp
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(),
                OutlineButton(
                  borderSide: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onSignUp,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onSignUp() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();

      setState(() {
        isSigningUp = true;
      });

      bool signedUpAndIn = await appProvider.addUser(
        email: _email.toLowerCase(),
        password: _password,
        firstName: _firstName,
        lastName: _lastName,
        imageFile: imagefile,
      );

      if (signedUpAndIn) {
        await appProvider.signIn(_email, _password);

        setState(() {
          isSigningUp = false;
        });

        Navigator.pop(context);
      } else {
        showToast(
          context: context,
          message: 'Email already in use!',
          duration: Duration(milliseconds: 2000),
        );

        setState(() {
          isSigningUp = false;
        });
      }
    }
  }

  String _emailValidator(String value) {
    if (value.isEmpty) {
      return '*Required.';
    } else if (!value.contains('@')) {
      return 'Enter a valid Email.';
    } else if (value.contains(' ')) {
      return 'Email cannot contain a space.';
    } else {
      return null;
    }
  }

  String _passwordValidator(String value) {
    if (value.isEmpty) {
      return '*Required.';
    } else if (value.length < 6) {
      return 'Password must be 6 characters long.';
    } else if (value.contains(' ')) {
      return 'Password cannot contain a space.';
    } else {
      return null;
    }
  }
}
