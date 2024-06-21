import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/model/momo/review_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/save_momo_view_model.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class MoMoDetails extends ConsumerStatefulWidget {
  final MoMoApiModel moApiModel;

  const MoMoDetails({super.key, required this.moApiModel});

  @override
  ConsumerState<MoMoDetails> createState() => _MoMoDetailsState();
}

class _MoMoDetailsState extends ConsumerState<MoMoDetails> {
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
    Map<String, double> averages =
        _calculateAverageRatings(widget.moApiModel.reviews ?? []);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  var userId =
                      await ref.read(userSharedPrefsProvider).getUserDetails();
                  userId.fold((l) {
                    return SnackBarManager.showSnackBar(
                        isError: true,
                        message: "User not found",
                        context: context);
                  }, (r) {
                    ref.read(saveMoMoViewModelProvider.notifier).saveMoMo(
                          userId: r['_id'],
                          momoId: widget.moApiModel.id!,
                          context: context,
                        );
                  });
                },
                icon: const Icon(Icons.bookmark))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    widget.moApiModel.momoName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                lab,
                SizedBox(
                  height: 100,
                  width: 100,
                  child: widget.moApiModel.momoImage != null
                      ? Image.network(widget.moApiModel.momoImage!)
                      : const Image(image: AssetImage("image/mmm.png")),
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
                            widget.moApiModel.shop,
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
                            widget.moApiModel.location,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                lab,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.moApiModel.reviews?.length ?? 0} reviews",
                      style: const TextStyle(
                          color: Color(0xff6d6d6d), fontSize: 15),
                    )
                  ],
                ),
                lab,
                _buildRatingRow("Overall Rating", averages['overallRating']!),
                _buildRatingRow("Filling Amount", averages['fillingAmount']!),
                _buildRatingRow("Size of Momo", averages['sizeOfMomo']!),
                _buildRatingRow("Sauce Variety", averages['sauceVariety']!),
                _buildRatingRow("Aesthetic", averages['aesthetic']!),
                _buildRatingRow("Spice Level", averages['spiceLevel']!),
                _buildRatingRow("Price Value", averages['priceValue']!),
                lab,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Reviews",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                ..._buildReviewList(widget.moApiModel.reviews),
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

  List<Widget> _buildReviewList(List<Review>? reviews) {
    if (reviews == null || reviews.isEmpty) {
      return [const Text("No reviews available")];
    }

    return reviews.map((review) {
      return Container(
        decoration: const BoxDecoration(
            border: BorderDirectional(
                bottom: BorderSide(
                    width: 1, style: BorderStyle.solid, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(review.review),
        ),
      );
    }).toList();
  }
}
