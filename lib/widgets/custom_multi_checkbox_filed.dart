import 'package:flutter/material.dart';

class MultiSelectCheckboxList extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;

  const MultiSelectCheckboxList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: SizedBox(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: items.map((item) {
                  return CheckboxListTile(
                    title: Text(
                      item,
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black87),
                    ),
                    value: selectedItems.contains(item),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    onChanged: (bool? value) {
                      List<String> updatedSelection = List.from(selectedItems);
                      if (value == true) {
                        updatedSelection.add(item);
                      } else {
                        updatedSelection.remove(item);
                      }
                      onSelectionChanged(updatedSelection);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
