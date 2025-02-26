import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;
  final TextInputType keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isMultiline = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: isMultiline ? 3 : 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
    );
  }
}
