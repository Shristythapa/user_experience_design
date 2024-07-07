// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:momo_rating_app_frontend/main.dart';

// class DiteFilter extends StatefulWidget {
//   Set<Dite> filters;
//   final Function(Set<Dite>) onSelectionChanged;
//   DiteFilter({
//     super.key,
//     required this.filters,
//     required this.onSelectionChanged,
//   });

//   @override
//   State<DiteFilter> createState() => _DiteFilterState();
// }

// class _DiteFilterState extends State<DiteFilter> {
//   // enum ExerciseFilter {}
//   Set<Dite> filters = <Dite>{};

//   @override
//   void initState() {
//     super.initState();
//     // Initialize filters with the passed filters
//     filters = widget.filters;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const SizedBox(height: 20.0),
//         Wrap(
//           spacing: 5.0,
//           children: Dite.values.map((Dite dite) {
//             return FilterChip(
//               selectedColor: Colors.amber,
//               disabledColor: Colors.grey,
//               label: Text(dite.name),
//               selected: filters.contains(dite),
//               onSelected: (bool selected) {
//                 setState(() {
//                   if (selected) {
//                     filters.add(dite);
//                   } else {
//                     filters.remove(dite);
//                   }
//                   // Call the callback function with updated filters
//                   widget.onSelectionChanged(filters);
//                 });
//               },
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 10.0),
//       ],
//     );
//   }
// }
