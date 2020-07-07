import 'package:flutter/material.dart';

typedef Validator = String Function(String value);

class CustomTextFormField extends StatelessWidget {
  final String label;
  final Icon suffixIcon;
  final Function onSaved;
  final Validator validator;
  final bool obscureText;
  final bool enabled;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  CustomTextFormField({
    this.label,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.hintText,
    this.controller,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? null,
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? Colors.green : Colors.grey[800],
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: enabled ? Colors.green : Colors.grey[800],
        ),
      ),
      style: TextStyle(color: enabled ? Colors.white : Colors.grey[800]),
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
    );
  }
}
