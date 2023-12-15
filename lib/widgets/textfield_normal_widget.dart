import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldNormalWidget extends StatelessWidget {
  String hintText;
  bool isNumber = false;
  VoidCallback? onMandarina;
  TextEditingController controller;

  TextFieldNormalWidget({
    required this.hintText,
    this.isNumber = false,
    this.onMandarina,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onTap: onMandarina,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Colors.black.withOpacity(0.40),
        ),
        filled: true,
        fillColor: const Color(0xff101321).withOpacity(0.05),
        contentPadding: const EdgeInsets.all(12.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
