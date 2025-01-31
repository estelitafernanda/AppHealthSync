import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validateFunction;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextFormField(
      {super.key,
        required this.labelText,
        this.validateFunction,
        this.controller,
        this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        validator: validateFunction,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          border: OutlineInputBorder(
            borderSide:
            BorderSide(color: Color(4289382399)),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Color(4289382399)),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Color(4289382399)),
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Color(4289382399),
          filled: true,
        ),
      ),
    );
  }
}