import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<String> items;

  const CustomDropdownButtonFormField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          prefixIcon: Icon(prefixIcon, color: Colors.blue),
        ),
        dropdownColor: Colors.white,
        initialValue: value,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
