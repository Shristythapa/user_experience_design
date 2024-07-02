import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/preferences/preferences_model.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/cook_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/filling_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/dite_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/preference_view_model.dart';

class AddPreferencesPage extends ConsumerStatefulWidget {
  const AddPreferencesPage({super.key});

  @override
  ConsumerState<AddPreferencesPage> createState() => _AddPreferencesPageState();
}

class _AddPreferencesPageState extends ConsumerState<AddPreferencesPage> {
  Set<Dite> diteFilters = {};
  Set<FillingType> fillingFilters = {};
  Set<CookType> cookFilters = {};
  @override
  Widget build(BuildContext context) {
    final prefState = ref.watch(preferenceViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefState.showMessage) {
        SnackBarManager.showSnackBar(
            isError: ref.read(preferenceViewModelProvider).isError,
            message: ref.read(preferenceViewModelProvider).message,
            context: context);
        ref.read(preferenceViewModelProvider.notifier).resetState();
      }
    });
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add Preferences",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Dite",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  DiteFilter(
                    filters: diteFilters,
                    onSelectionChanged: (Set<Dite> dite) {
                      diteFilters = dite;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  const Text(
                    "Filling Type",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  FillingFilter(
                    filters: fillingFilters,
                    onSelectionChanged: (Set<FillingType> filling) {
                      fillingFilters = filling;
                    },
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Cook Type",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  CookFilter(
                    filters: cookFilters,
                    onSelectionChanged: (Set<CookType> selectedFilters) {
                      cookFilters = selectedFilters;
                    },
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            //  style: ButtonStyle(backgroundColor: Colors.ye),
                            onHover: (value) {
                              setState(() {
                                ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff43B13A));
                              });
                            },
                            onPressed: (() async {
                              var userId = await ref
                                  .read(userSharedPrefsProvider)
                                  .getUserDetails();
                              userId.fold((l) {
                                return SnackBarManager.showSnackBar(
                                    isError: true,
                                    message: "User not found",
                                    context: context);
                              }, (r) {
                                PreferenceModel preferenceModel =
                                    PreferenceModel(
                                  userId: r['_id'],
                                  cookType: cookFilters.toList(),
                                  fillingType: diteFilters.toList(),
                                  filling: fillingFilters.toList(),
                                );

                                ref
                                    .read(preferenceViewModelProvider.notifier)
                                    .addPreference(preferenceModel, context);
                              });
                            }),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
          if (prefState.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
