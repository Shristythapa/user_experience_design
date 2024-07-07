import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/rating_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class ReviewList extends ConsumerStatefulWidget {
  const ReviewList({super.key});

  @override
  ConsumerState<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends ConsumerState<ReviewList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(reviewViewModelProvider.notifier)
          .getRatings(ref.read(userViewModelProvider).userDetails!['_id']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewViewModelProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Reviews",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: state.review.isEmpty
            ? const Center(
                child: Text("No reviews added"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
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
                                .read(reviewViewModelProvider.notifier)
                                .getRatingById(
                                    state.review[index].reviewId!, context);
                          });
                        },
                        child: buildReviewCard(
                            state.review[index].image!,
                            state.review[index].cookType!,
                            state.review[index].fillingType!,
                            state.review[index].review,
                            state.review[index].overallRating.toDouble()));
                  },
                  itemCount: state.review.length,
                ),
              ),
      ),
    );
  }
}

Widget buildReviewCard(
    String image, String title, String cook, String review, double stars) {
  return Column(
    children: [
      Card(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Text(
                      RegExp(r'\.(.*?)\}').firstMatch(title) != null
                          ? "${RegExp(r'\.(.*?)\}').firstMatch(title)!.group(1)!} ${RegExp(r'\.(.*?)\}').firstMatch(cook)!.group(1)!}"
                          : '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    RatingStars(
                      rating: stars,
                      editable: true,
                      iconSize: 28,
                      color: const Color.fromARGB(255, 255, 187, 52),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ) 
    ],
  );
}
