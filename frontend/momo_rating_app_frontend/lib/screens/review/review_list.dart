import 'package:flutter/material.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class ReviewList extends StatefulWidget {
  const ReviewList({super.key});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildReviewCard(),
          ],
        ),
      ),
    );
  }
}

Widget buildReviewCard() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    color: Colors.white,
    child: Container(
      width: 380,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("image/mmm.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const Text(
                  "Veg momo",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                RatingStars(
                  rating: 3,
                  editable: true,
                  iconSize: 28,
                  color: const Color.fromARGB(255, 255, 187, 52),
                ),
              ],
            ),
            const Text(
                "Nice nice nice good food nice momo more better possible..")
          ],
        ),
      ),
    ),
  );
}
