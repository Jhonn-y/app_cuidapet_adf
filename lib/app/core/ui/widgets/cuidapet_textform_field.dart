import 'package:flutter/material.dart';

class CuidapetTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueNotifier<bool> _obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  CuidapetTextFormField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validator,
  }) : _obscureTextVN = ValueNotifier<bool>(obscureText);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextVN,
      builder: (_, obscureTextVN, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureTextVN,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              gapPadding: 0,
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      _obscureTextVN.value = !obscureTextVN;
                    },
                    icon: Icon(
                      obscureTextVN ? Icons.lock : Icons.lock_open,
                      color: Colors.black,
                    ))
                : null,
          ),
        );
      },
    );
  }
}
