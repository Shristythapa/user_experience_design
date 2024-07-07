import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class SearchResult extends ConsumerStatefulWidget {
  const SearchResult({super.key});

  @override
  ConsumerState<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SearchResult> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moMoViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showMessage) {
        SnackBarManager.showSnackBar(
            isError: ref.read(moMoViewModelProvider).isError,
            message: ref.read(moMoViewModelProvider).message,
            context: context);
        ref.read(moMoViewModelProvider.notifier).resetState();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainDashboard(),
                ),
              );
            },
          ),
          title: const Text(
            "Search Result",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
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
                        .getMomoById(state.momo[index].id!, r['_id'], context);
                  });
                },
                child: buildCard(
                    state.momo[index].momoImage ?? 'image/mmm.png',
                    state.momo[index].fillingType,
                    state.momo[index].cookType,
                    state.momo[index].shop,
                    state.momo[index].location,
                    state.momo[index].momoPrice,
                    state.momo[index].overallRating ?? 0.0),
              );
            },
            itemCount: state.momo.length,
          ),
        ),
      ),
    );
  }
}

Widget buildCard(String image, String title, String cook, String shop,
    String location, String price, double rating) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    color: Colors.white,
    child: Container(
      width: 380,
      height: 150,
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
                          RegExp(r'\.(.*?)\}').firstMatch(title) != null
                              ? "${RegExp(r'\.(.*?)\}').firstMatch(title)!.group(1)!} ${RegExp(r'\.(.*?)\}').firstMatch(cook)!.group(1)!}"
                              : '',
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
