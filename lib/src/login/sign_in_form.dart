import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_text_form_field.dart';
import '../providers/app_provider.dart';
import '../widgets/toast.dart';

class SignInForm extends StatefulWidget {
  SignInForm({Key key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _signInFormKey = GlobalKey();

  String _email, _password;
  bool _isSigningIn;

  @override
  void initState() {
    super.initState();

    _email = _password = '';
    _isSigningIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Form(
          key: _signInFormKey,
          child: Column(
            children: <Widget>[
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
                  obscureText: true,
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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: onSignIn,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        _isSigningIn
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }

  void onSignIn() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_signInFormKey.currentState.validate()) {
      _signInFormKey.currentState.save();

      setState(() {
        _isSigningIn = true;
      });

      bool signedIn = await appProvider.signIn(_email.toLowerCase(), _password);

      setState(() {
        _isSigningIn = false;
      });

      if (signedIn) {
        Navigator.pop(context);
      } else {
        showToast(
          context: context,
          message: 'Error: Invalid email or password!',
          duration: Duration(milliseconds: 2000),
        );
      }
    }
  }

  String _emailValidator(String value) {
    if (value.isEmpty) {
      return 'Email cannot be empty.';
    }  else {
      return null;
    }
  }

  String _passwordValidator(String value) {
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    } else {
      return null;
    }
  }
}
