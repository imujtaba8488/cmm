import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/basic_dialog.dart';
import '../providers/app_provider.dart';

class SignInSignUpDialog extends StatefulWidget {
  @override
  _SignInSignUpDialogState createState() => _SignInSignUpDialogState();
}

class _SignInSignUpDialogState extends State<SignInSignUpDialog> {
  GlobalKey<FormState> _signInFormKey = GlobalKey();
  GlobalKey<FormState> _signUpFormKey = GlobalKey();
  int activeTab = 0;

  String firstName, lastName, email, password;

  @override
  void initState() {
    super.initState();

    firstName = lastName = email = password = '';
  }

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
                      child: _signInForm(),
                    ),

                    // If a container is not displayed during the tab switch to tab0, renderflex error is thrown because of the height change.
                    activeTab == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _signUpForm(),
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

  Widget _signInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _customTextField(
              label: 'Email',
              suffixIcon: Icon(
                Icons.email,
                color: Colors.green,
              ),
              onSaved: (value) => email = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _customTextField(
              label: 'Password',
              suffixIcon: Icon(
                Icons.lock,
                color: Colors.green,
              ),
              onSaved: (value) => password = password,
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
    );
  }

  Widget _signUpForm() {
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
                  child: _customTextField(
                    label: 'First Name',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _customTextField(
                    label: 'Last Name',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _customTextField(
              label: 'Email',
              suffixIcon: Icon(
                Icons.email,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _customTextField(
              label: 'Password',
              suffixIcon: Icon(
                Icons.lock,
                color: Colors.green,
              ),
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
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _customTextField({
    String label = 'label',
    Icon suffixIcon,
    Function onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? null,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.green,
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      onSaved: onSaved,
    );
  }

  void onSignIn() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_signInFormKey.currentState.validate()) {
      _signInFormKey.currentState.save();

      bool signedIn = await appProvider.signIn(email, password);

      if (signedIn) {
        
        print('user exists signing in');

        Navigator.pop(context);
      }
    }
  }

  void onSignUp() {}
}
