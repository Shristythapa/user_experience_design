import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/cook_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/filling_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/dite_filter.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/rating_view_model.dart';

class AddReview extends ConsumerStatefulWidget {
  const AddReview({super.key});

  @override
  ConsumerState<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends ConsumerState<AddReview> {
  Set<Dite> diteFilters = {};
  Set<FillingType> fillingFilters = {};
  Set<CookType> cookFilters = {};
  int sizeOfMomo = 0;
  int aesthetics = 0;
  int fillingAmount = 0;
  int priceValue = 0;
  int spicyLevel = 0;
  int sauceVariety = 0;
  int overallTaste = 0;
  TextEditingController review = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewViewModelProvider);
    TextEditingController review = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showMessage) {
        SnackBarManager.showSnackBar(
            message: state.message, context: context, isError: state.isError);
        ref.read(reviewViewModelProvider.notifier).resetState();
      }
    });
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add Review",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainDashboard()),
                      );
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiteFilter(
                      filters: diteFilters,
                      onSelectionChanged: (Set<Dite> dite) {
                        diteFilters = dite;
                      },
                    ),
                    FillingFilter(
                      filters: fillingFilters,
                      onSelectionChanged: (Set<FillingType> filling) {
                        fillingFilters = filling;
                      },
                    ),
                    CookFilter(
                      filters: cookFilters,
                      onSelectionChanged: (Set<CookType> selectedFilters) {
                        cookFilters = selectedFilters;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Size of Momo",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    // reviews
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        sizeOfMomo = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Filling Amount",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    // reviews
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        fillingAmount = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Aesthetics",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        aesthetics = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Price Value",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        priceValue = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Spice Level",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        spicyLevel = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Sauce Varity",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        sauceVariety = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Overall Taste",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      minRating: 0,
                      maxRating: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        overallTaste = rating.toInt();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      controller: review,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Review";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red[900]),
                        labelText: "Review",
                        labelStyle: const TextStyle(
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var userId = await ref
                            .read(userSharedPrefsProvider)
                            .getUserDetails();
                        userId.fold((l) {
                          return SnackBarManager.showSnackBar(
                              isError: true,
                              message: "User not found",
                              context: context);
                        }, (r) {
                          ref.read(reviewViewModelProvider.notifier).addRating(
                              review: Review(
                                  userId: r['_id'],
                                  momoId: "",
                                  overallRating: overallTaste,
                                  fillingAmount: fillingAmount,
                                  sizeOfMomo: sizeOfMomo,
                                  sauceVariety: sauceVariety,
                                  aesthectic: aesthetics,
                                  spiceLevel: spicyLevel,
                                  priceValue: priceValue,
                                  review: review.text),
                              context: context);
                        });
                      },
                      child: const Text("Add Rewiew"),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (state.isLoading)
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
