// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/main.dart';

class CookFilter extends StatefulWidget {
  Set<CookType> filters;
  final Function(Set<CookType>) onSelectionChanged;
  CookFilter({
    super.key,
    required this.filters,
    required this.onSelectionChanged,
  });

  @override
  State<CookFilter> createState() => _CookFilterState();
}

class _CookFilterState extends State<CookFilter> {
  // enum ExerciseFilter {}
  Set<CookType> filters = <CookType>{};

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
          children: CookType.values.map((CookType dite) {
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
