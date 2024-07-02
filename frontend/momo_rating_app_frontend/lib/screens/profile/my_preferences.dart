import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/utils/cook_chip_list.dart';
import 'package:momo_rating_app_frontend/core/utils/dite_list_chip.dart';
import 'package:momo_rating_app_frontend/core/utils/filling_list_chip.dart';

import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/preference_view_model.dart';

class MyPreferences extends ConsumerStatefulWidget {
  const MyPreferences({super.key});

  @override
  ConsumerState<MyPreferences> createState() => _MyPreferencesState();
}

class _MyPreferencesState extends ConsumerState<MyPreferences> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(preferenceViewModelProvider.notifier).getPreferences(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceViewModelProvider);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed functionality here
            // This is where you would typically navigate to the edit screen or perform an edit action
          },
          tooltip: 'Edit',
          child: const Icon(Icons.edit),
        ),
        appBar: AppBar(
          title: const Text(
            "My Preferences",
            style: TextStyle(
                color: Color(0xff000000),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: state.preferenceModel != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Dite",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    DiteListChip(
                      selectedItems: state.preferenceModel!.fillingType,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Filling Type",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    FillingListChip(
                      selectedItems: state.preferenceModel!.filling,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Cook Type",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    CookChipList(
                      selectedItems: state.preferenceModel!.cookType,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No preferences available",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
        ),
      ),
    );
  }
}
