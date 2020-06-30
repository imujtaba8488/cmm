import 'package:flutter/material.dart';

typedef Validator = String Function(String value);

class CustomTextFormField extends StatelessWidget {
  final String label;
  final Icon suffixIcon;
  final Function onSaved;
  final Validator validator;
  final bool obscureText;

  CustomTextFormField({
    this.label,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
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
      validator: validator,
      obscureText: obscureText,
    );
  }
}
