import 'package:flutter/material.dart';

class AuthTextFieldWidget extends StatelessWidget {
  const AuthTextFieldWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.isObsecure = false,
    this.validator,
    this.suffixIcon,
    required this.controller,
  });
  final String labelText;
  final String hintText;
  final bool isObsecure;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecure,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
