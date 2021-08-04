import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String fillHint;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final Function()? onTap;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.fillHint,
    required this.textInputAction,
    required this.textInputType,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofillHints: [fillHint],
      textInputAction: textInputAction,
      keyboardType: textInputType,
      style: TextStyle(
          fontFamily: 'sf',
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400),
      decoration: new InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontFamily: 'sf', color: Colors.black),
        // filled: true,
        contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 14),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        isDense: true,
      ),
      onTap: onTap,
    );
  }
}
