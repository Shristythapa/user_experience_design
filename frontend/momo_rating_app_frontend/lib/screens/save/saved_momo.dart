import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/save_momo_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class SavedMomos extends ConsumerStatefulWidget {
  const SavedMomos({super.key});

  @override
  ConsumerState<SavedMomos> createState() => _SavedMomosState();
}

class _SavedMomosState extends ConsumerState<SavedMomos> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(saveMoMoViewModelProvider.notifier)
          .getSavedMomo(ref.read(userViewModelProvider).userDetails!['_id']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saveMoMoViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showMessage) {
        SnackBarManager.showSnackBar(
            isError: ref.read(saveMoMoViewModelProvider).isError,
            message: ref.read(saveMoMoViewModelProvider).message,
            context: context);
        ref.read(saveMoMoViewModelProvider.notifier).resetState();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Saved MoMo",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                var userId =
                    await ref.read(userSharedPrefsProvider).getUserDetails();
                userId.fold((l) {
                  return SnackBarManager.showSnackBar(
                      isError: true,
                      message: "User not found",
                      context: context);
                }, (r) {
                  ref
                      .read(moMoViewModelProvider.notifier)
                      .getMomoById(state.momos[index].id!, r['_id'], context);
                });
              },
              child: buildCard(
                  state.momos[index].momoImage ?? 'image/mmm.png',
                  state.momos[index].fillingType,
                  state.momos[index].location,
                  state.momos[index].location,
                  state.momos[index].momoPrice,
                  state.momos[index].overallRating ?? 0.0),
            );
          },
          itemCount: state.momos.length,
        ),
      ),
    );
  }
}

Widget buildCard(String image, String title, String shop, String location,
    String price, double rating) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    color: Colors.white,
    child: Container(
      width: 380,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant,
                              size: 20,
                            ),
                            Text(
                              shop,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                            ),
                            Text(
                              location,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                RatingStars(
                  rating: rating,
                  editable: true,
                  iconSize: 28,
                  color: const Color.fromARGB(255, 255, 187, 52),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
