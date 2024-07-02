// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/main.dart';

class FillingFilter extends StatefulWidget {
  Set<FillingType> filters;
  final Function(Set<FillingType>) onSelectionChanged;
  FillingFilter({
    super.key,
    required this.filters,
    required this.onSelectionChanged,
  });

  @override
  State<FillingFilter> createState() =>
      _FillingFilterState();
}

class _FillingFilterState extends State<FillingFilter> {
  // enum ExerciseFilter {}
  Set<FillingType> filters = <FillingType>{};

  @override
  void initState() {
    super.initState();
    // Initialize filters with the passed filters
    filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 5.0,
          children: FillingType.values.map((FillingType dite) {
            return FilterChip(
              selectedColor: Colors.amber,
              disabledColor: Colors.grey,
              label: Text(dite.name),
              selected: filters.contains(dite),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    filters.add(dite);
                  } else {
                    filters.remove(dite);
                  }
                  // Call the callback function with updated filters
                  widget.onSelectionChanged(filters);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
