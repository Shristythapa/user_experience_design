import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/dashboard_view_model.dart';

class MainDashboard extends ConsumerStatefulWidget {
  const MainDashboard({super.key});

  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MainDashboardState = ref.watch(dashboardViewModelProvider);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: MainDashboardState.listWidget[MainDashboardState.index],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 25,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 25,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 25,
                ),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.save,
                  size: 25,
                ),
                label: 'Saved MoMo',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                  size: 25,
                ),
                label: 'Reviews',
              ),
            ],
            currentIndex: MainDashboardState.index,
            iconSize: 28,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            onTap: (index) {
              ref.read(dashboardViewModelProvider.notifier).changeIndex(index);
            }),
      ),
    );
  }
}
