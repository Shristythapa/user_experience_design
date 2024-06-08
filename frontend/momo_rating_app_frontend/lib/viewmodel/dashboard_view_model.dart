import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/dashboard_state.dart';

final dashboardViewModelProvider =
    StateNotifierProvider.autoDispose<DashboardViewModel, DashboardState>(
        (ref) => DashboardViewModel());

class DashboardViewModel extends StateNotifier<DashboardState> {
  DashboardViewModel() : super(DashboardState.initialState());

  void changeIndex(int index) {
    state = state.copyWith(index: index);
  }
}
