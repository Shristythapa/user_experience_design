import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/screens/add/add_momo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/home.dart';
import 'package:momo_rating_app_frontend/screens/review/review_list.dart';
import 'package:momo_rating_app_frontend/screens/save/saved_momo.dart';
import 'package:momo_rating_app_frontend/screens/search/search_page.dart';

class DashboardState {
  final int index;
  final List<Widget> listWidget;

  DashboardState({required this.index, required this.listWidget});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  DashboardState.initialState()
      : index = 0,
        listWidget = [
          const Dashboard(),
          const SearchPage(),
          const AddMoMo(),
          const SavedMomos(),
          const ReviewList(),
        ];

  DashboardState copyWith({int? index}) {
    return DashboardState(index: index ?? this.index, listWidget: listWidget);
  }
}
