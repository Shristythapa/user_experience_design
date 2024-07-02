import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/main.dart';

// ignore: must_be_immutable
class FillingListChip extends StatelessWidget {
  final List<FillingType> selectedItems;

  const FillingListChip({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 5.0,
          children: FillingType.values.map((FillingType fill) {
            bool isSelected = selectedItems.contains(fill);
            return Card(
              elevation: isSelected ? 4.0 : 0.0, // Add elevation if selected
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: isSelected ? Colors.amber : const Color(0xffE9E9E9),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Text(
                  fill.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
