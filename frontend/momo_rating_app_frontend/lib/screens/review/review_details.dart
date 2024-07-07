import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/rating_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class ReviewDetails extends ConsumerStatefulWidget {
  final Review review;
  const ReviewDetails({super.key, required this.review});

  @override
  ConsumerState<ReviewDetails> createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends ConsumerState<ReviewDetails> {
  late dynamic user; // Declare a variable to store the user information

  var lab = const SizedBox(height: 25);

  Future<void> _getUserDetails() async {
    var userResult = await ref.read(userSharedPrefsProvider).getUserDetails();
    userResult.fold(
      (failure) {
        SnackBarManager.showSnackBar(
          isError: true,
          message: "Token Invalid",
          context: context,
        );
      },
      (fetchedUser) {
        setState(() {
          user = fetchedUser; // Update the user variable with fetched user
        });
      },
    );
  }

  Map<String, double> _calculateAverageRatings(List<Review> reviews) {
    int totalReviews = reviews.length;

    double overallRating =
        reviews.fold(0, (sum, item) => sum + item.overallRating) / totalReviews;
    double fillingAmount =
        reviews.fold(0, (sum, item) => sum + item.fillingAmount) / totalReviews;
    double sizeOfMomo =
        reviews.fold(0, (sum, item) => sum + item.sizeOfMomo) / totalReviews;
    double sauceVariety =
        reviews.fold(0, (sum, item) => sum + item.sauceVariety) / totalReviews;
    double aesthetic =
        reviews.fold(0, (sum, item) => sum + item.aesthectic) / totalReviews;
    double spiceLevel =
        reviews.fold(0, (sum, item) => sum + item.spiceLevel) / totalReviews;
    double priceValue =
        reviews.fold(0, (sum, item) => sum + item.priceValue) / totalReviews;

    return {
      'overallRating': overallRating,
      'fillingAmount': fillingAmount,
      'sizeOfMomo': sizeOfMomo,
      'sauceVariety': sauceVariety,
      'aesthetic': aesthetic,
      'spiceLevel': spiceLevel,
      'priceValue': priceValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainDashboard()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    " Your Rating on ${RegExp(r'\.(.*?)\}').firstMatch(widget.review.fillingType!)!.group(1)!} ${RegExp(r'\.(.*?)\}').firstMatch(widget.review.cookType!)!.group(1)!} Momo",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                lab,
                SizedBox(
                  height: 100,
                  width: 100,
                  child: widget.review.image != null
                      ? Image.network(widget.review.image!)
                      : const Image(image: AssetImage("image/mmm.png")),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.review.shop!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.review.location!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                lab,
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
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
                            widget.review.momoId, r['_id'], context);
                      });
                    },
                    child: const Text(
                      textAlign: TextAlign.end,
                      "View other details",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xff353535),
                          fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lab,
                      _buildRatingRow("Overall Rating",
                          widget.review.overallRating.toDouble()),
                      _buildRatingRow("Filling Amount",
                          widget.review.fillingAmount.toDouble()),
                      _buildRatingRow(
                          "Size of Momo", widget.review.sizeOfMomo.toDouble()),
                      _buildRatingRow("Sauce Variety",
                          widget.review.sauceVariety.toDouble()),
                      _buildRatingRow(
                          "Aesthetic", widget.review.aesthectic.toDouble()),
                      _buildRatingRow(
                          "Spice Level", widget.review.spiceLevel.toDouble()),
                      _buildRatingRow(
                          "Price Value", widget.review.priceValue.toDouble()),
                      lab,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(child: Text(widget.review.review)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xffDB5858), // Change button color to red
                      ),
                      onPressed: () {
                        // ref
                        //     .read(reviewViewModelProvider.notifier)
                        //     .deleteReview(widget.review.reviewId!, context);
                        _showDeleteConfirmationDialog(context, ref);
                      },
                      child: const Text(
                        "Delete review",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Confirm Delete"),
  //         content: const Text("Are you sure you want to delete this review?"),
  //         actions: [
  //           TextButton(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("Delete"),
  //             onPressed: () {
  //               ref
  //                   .read(reviewViewModelProvider.notifier)
  //                   .deleteReview(widget.review.reviewId!, context);
  //               Navigator.of(context).pop(); // Close the dialog after deletion
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          title: const Text(
            textAlign: TextAlign.center,
            "Are you sure you want to delete this review?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Red background for Logout button
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Remove rounded corners
                  ),
                ),
                onPressed: () {
                  ref
                      .read(reviewViewModelProvider.notifier)
                      .deleteReview(widget.review.reviewId!, context);
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainDashboard()));
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange, // Orange background for Cancel button
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Remove rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingRow(String title, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        RatingStars(
          rating: rating,
          editable: false,
          iconSize: 50,
          color: const Color.fromARGB(255, 255, 187, 52),
        ),
        lab,
      ],
    );
  }
}
