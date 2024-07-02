import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moMoViewModelProvider.notifier).getAllMomos();
      ref.read(userViewModelProvider.notifier).getUserDetails();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.message != null) {
        SnackBarManager.showSnackBar(
            isError: ref.read(userViewModelProvider).isError,
            message: ref.read(userViewModelProvider).message!,
            context: context);
        ref.read(userViewModelProvider.notifier).resetState();
      }
    });
    final state = ref.watch(moMoViewModelProvider);
    final momoState = ref.watch(moMoViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (momoState.message != "" && momoState.showMessage) {
        SnackBarManager.showSnackBar(
            isError: momoState.isError,
            message: momoState.message,
            context: context);
        ref.read(moMoViewModelProvider.notifier).resetState();
      }
    });
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (_scrollController.position.extentAfter == 0) {
            ref.read(moMoViewModelProvider.notifier).getAllMomos();
          }
        }
        return true;
      },
      child: SafeArea(
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
                                : const AssetImage(
                                        'image/dummyProfileImage.jfif')
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
                              state.momo[index].location,
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

                          //     .then((value) {
                          //   value.fold((error) {
                          //     return;
                          //   }, (model) {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               MoMoDetails(moApiModel: model)),
                          //     );
                          //   });
                          // });
                        },
                        child: buildCard(
                            state.momo[index].momoImage ?? 'image/mmm.png',
                            state.momo[index].fillingType,
                            state.momo[index].location,
                            state.momo[index].location,
                            state.momo[index].momoPrice,
                            state.momo[index].overallRating ?? 0.0),
                      );
                    },
                    itemCount: state.momo.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String image, String type, String shop, String location,
      String price, double rating) {
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
          ), // Adjust the value for the desired border radius
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
                        ? RegExp(r'\.(.*?)\}').firstMatch(type)!.group(1)!
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
                  const Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 20,
                      ),
                      Text(
                        "Shandar",
                        style: TextStyle(
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
