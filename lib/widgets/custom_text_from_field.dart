import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Icon? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
          prefixIcon: prefixIcon,
        ),
        cursorColor: Colors.blue,
        style: const TextStyle(color: Colors.black, fontSize: 18.0),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
