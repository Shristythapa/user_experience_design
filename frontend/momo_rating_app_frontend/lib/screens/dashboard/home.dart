import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_popular_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_recommendation_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/rating_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final ScrollController _forYouScrollController = ScrollController();
  final ScrollController _popularScrollController = ScrollController();
  Future<void> fetchData(BuildContext context, WidgetRef ref) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userJson = prefs.getString('user')!;

      // Deserialize the JSON string to a map
      Map<String, dynamic> userData = jsonDecode(userJson);
      ref
          .read(recommedationMomoViewModelProvider.notifier)
          .getRecommendations(userData['_id']);
      ref.read(popularMomoViewModelProvider.notifier).getPopular();
    } catch (e) {
      // Handle any errors that may occur
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userViewModelProvider.notifier).getUserDetails();
      fetchData(context, ref);
    });

    super.initState();
  }

  @override
  void dispose() {
    _forYouScrollController.dispose();
    _popularScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    final state = ref.watch(recommedationMomoViewModelProvider);
    final popularState = ref.watch(popularMomoViewModelProvider);
    ref.watch(reviewViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.message != null) {
        SnackBarManager.showSnackBar(
            isError: ref.read(userViewModelProvider).isError,
            message: ref.read(userViewModelProvider).message!,
            context: context);
        ref.read(userViewModelProvider.notifier).resetState();
      }
      // if (reviewState.message.isNotEmpty && reviewState.showMessage) {
      //   SnackBarManager.showSnackBar(
      //       isError: reviewState.isError,
      //       message: reviewState.message,
      //       context: context);
      //   ref.read(reviewViewModelProvider.notifier).resetState();
      // }
    });

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "get your perfect momo",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      },
                      child: CircleAvatar(
                          radius: 30,
                          backgroundImage: userState.userDetails != null
                              ? userState.userDetails!['profileImageUrl'] !=
                                      null
                                  ? NetworkImage(
                                      '${userState.userDetails!['profileImageUrl']}')
                                  : const AssetImage(
                                          'image/dummyProfileImage.jfif')
                                      as ImageProvider
                              : const AssetImage('image/dummyProfileImage.jfif')
                                  as ImageProvider),
                    ),
                  ),
                ],
              ),
              const Text(
                "For you",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _forYouScrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () async {
                          var userId = await ref
                              .read(userSharedPrefsProvider)
                              .getUserDetails();
                          userId.fold((l) {
                            return SnackBarManager.showSnackBar(
                                isError: true,
                                message: "User not found",
                                context: context);
                          }, (r) {
                            ref
                                .read(moMoViewModelProvider.notifier)
                                .getMomoById(
                                    state.momo[index].id!, r['_id'], context);
                          });
                        },
                        child: buildCard(
                            state.momo[index].momoImage ?? 'image/mmm.png',
                            state.momo[index].fillingType,
                            state.momo[index].cookType,
                            state.momo[index].shop,
                            state.momo[index].location,
                            state.momo[index].momoPrice,
                            state.momo[index].overallRating ?? 0.0));
                  },
                  itemCount: state.momo.length,
                ),
              ),
              const Text(
                "Popular",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _popularScrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        var userId = await ref
                            .read(userSharedPrefsProvider)
                            .getUserDetails();
                        userId.fold((l) {
                          return SnackBarManager.showSnackBar(
                              isError: true,
                              message: "User not found",
                              context: context);
                        }, (r) {
                          ref.read(moMoViewModelProvider.notifier).getMomoById(
                              state.momo[index].id!, r['_id'], context);
                        });
                      },
                      child: buildCard(
                          popularState.momo[index].momoImage ?? 'image/mmm.png',
                          popularState.momo[index].fillingType,
                          popularState.momo[index].cookType,
                          popularState.momo[index].shop,
                          popularState.momo[index].location,
                          popularState.momo[index].momoPrice,
                          popularState.momo[index].overallRating ?? 0.0),
                    );
                  },
                  itemCount: state.momo.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String image, String type, String cook, String shop,
      String location, String price, double rating) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        child: Container(
          width: 200,
          height: 230,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: Image(image: NetworkImage(image)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    RegExp(r'\.(.*?)\}').firstMatch(type) != null
                        ? "${RegExp(r'\.(.*?)\}').firstMatch(type)!.group(1)!} ${RegExp(r'\.(.*?)\}').firstMatch(cook)!.group(1)!}"
                        : '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
              ),
              RatingStars(
                rating: rating,
                editable: true,
                iconSize: 28,
                color: const Color.fromARGB(255, 255, 187, 52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
