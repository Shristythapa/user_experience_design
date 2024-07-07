import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/screens/auth/signup.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("image/momo_background2.jpg"),
                fit: BoxFit.cover),
          ),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "MoMoMatch",
                        style: TextStyle(
                            color: Color(0xffFFA70B),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "MoMo Rating and \nRecommendations",
                        style: TextStyle(
                            color: Color(0xffF1BA0C),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // Image(
                //   width: MediaQuery.of(context)
                //       .size
                //       .width, // Adjust this value as needed
                //   image: const AssetImage("image/mmm.png"),
                // ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
