import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class ReviewDetails extends ConsumerStatefulWidget {
  const ReviewDetails({super.key});

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
                const Center(
                  child: Text(
                    " Your Rating on Buff Momo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                lab,
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: Image(image: AssetImage("image/mmm.png")),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant, size: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "shop",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "location",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                lab,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(
                //       "${widget.moApiModel.reviews?.length ?? 0} reviews",
                //       style: const TextStyle(
                //           color: Color(0xff6d6d6d), fontSize: 15),
                //     )
                //   ],
                // ),
                const SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    // onTap: (){

                    // },
                    child: Text(
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
                      _buildRatingRow("Overall Rating", 3),
                      _buildRatingRow("Filling Amount", 3),
                      _buildRatingRow("Size of Momo", 3),
                      _buildRatingRow("Sauce Variety", 3),
                      _buildRatingRow("Aesthetic", 3),
                      _buildRatingRow("Spice Level", 3),
                      _buildRatingRow("Price Value", 3),
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
                        decoration: const BoxDecoration(
                            border: BorderDirectional(
                                bottom: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.black))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Nice stuff'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

  // List<Widget> _buildReviewList(List<Review>? reviews) {
  //   if (reviews == null || reviews.isEmpty) {
  //     return [const Text("No reviews available")];
  //   }
  //   return reviews.map((review) {
  //     return Container(
  //       decoration: const BoxDecoration(
  //           border: BorderDirectional(
  //               bottom: BorderSide(
  //                   width: 1, style: BorderStyle.solid, color: Colors.black))),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10.0),
  //         child: Text(review.review),
  //       ),
  //     );
  //   }).toList();
  // }
}
