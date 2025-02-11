import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/preferences/preferences_model.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';

import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/preference_view_model.dart';

class AddPreferencesPage extends ConsumerStatefulWidget {
  const AddPreferencesPage({super.key});

  @override
  ConsumerState<AddPreferencesPage> createState() => _AddPreferencesPageState();
}

class _AddPreferencesPageState extends ConsumerState<AddPreferencesPage> {
  // Set<Dite> diteFilters = {};
  final List<FillingType> selectedFilling = [];
  final List<CookType> selectedCook = [];
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
               

                  buildPreferenceSection<FillingType>(
                      'Filling', FillingType.values, selectedFilling),

                  const SizedBox(
                    height: 30,
                  ),

                  buildPreferenceSection<CookType>(
                      'Cook', CookType.values, selectedCook),

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
                                if(selectedCook.isEmpty || selectedCook.isEmpty){
                                    return SnackBarManager.showSnackBar(
                                      isError: true,
                                      message: "Preferences are required",
                                      context: context);
                                }
                                PreferenceModel preferenceModel =
                                    PreferenceModel(
                                  userId: r['_id'],
                                  cookType: selectedCook,
                                  // fillingType: diteFilters.toList(),
                                  filling: selectedFilling,
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

  Widget buildPreferenceSection<T>(
      String title, List<T> values, List<T> selectedValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            final isSelected = selectedValues.contains(value);
            return ChoiceChip(
              label: Text(value.toString().split('.').last),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(value);
                  } else {
                    selectedValues.remove(value);
                  }
                });
              },
              selectedColor: Colors.amber,
              backgroundColor: const Color(0xffF1F1F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.amber : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(
          color: Color(0xffAEAEAE),
        )
      ],
    );
  }
}
