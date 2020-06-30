import 'package:cmm/src/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_text_form_field.dart';
import '../providers/app_provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _signUpFormKey = GlobalKey();

  String _firstName, _lastName, _email, _password;

  @override
  void initState() {
    super.initState();

    _firstName = _lastName = _email = _password = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/test.jpg'),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    label: 'First Name',
                    onSaved: (value) => _firstName = value,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    label: 'Last Name',
                    onSaved: (value) => _lastName = value,
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
              onSaved: (value) => _email = value,
              validator: (String value) {
                if (value.isEmpty) {
                  return '*Required.';
                } else if (!value.contains('@')) {
                  return 'Enter a valid Email.';
                } else {
                  return null;
                }
              },
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
              onSaved: (value) => _password = value,
              validator: (String value) {
                if (value.isEmpty) {
                  return '*Required.';
                } else if (value.length < 6) {
                  return 'Password must be 6 characters long.';
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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

      bool signedUpAndIn = await appProvider.addUser(
        email: _email,
        password: _password,
        firstName: _firstName,
        lastName: _lastName,
      );

      if (signedUpAndIn) {
        appProvider.signIn(_email, _password);
        Navigator.pop(context);
      }
    }
  }
}