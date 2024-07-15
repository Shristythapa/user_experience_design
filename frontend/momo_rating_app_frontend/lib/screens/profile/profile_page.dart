import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/profile/faq_page.dart';
import 'package:momo_rating_app_frontend/screens/profile/my_preferences.dart';
import 'package:momo_rating_app_frontend/screens/profile/ui_flow_diagram.dart';
import 'package:momo_rating_app_frontend/screens/startings/landing.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:photo_view/photo_view.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userViewModelProvider.notifier).getUserDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
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
          body: Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF6D3F83),
                    radius: 70,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${userState.userDetails!['profileImageUrl']}'),
                      radius: 70,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          " ${userState.userDetails!['userName']}",
                          style: const TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          "${userState.userDetails!['email']}",
                          style: const TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Settings",
                  style: TextStyle(
                      fontFamily: 'nunitoSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyPreferences()),
                    );
                  },
                  child: const Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.favorite_border),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    "Your Momo Preferences",
                                    style: TextStyle(
                                        fontFamily: 'nunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FaqPage()),
                    );
                  },
                  child: const Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.question_mark_outlined),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    "FAQ",
                                    style: TextStyle(
                                        fontFamily: 'nunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UiFlowDiagram()),
                    );
                  },
                  child: const Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.search),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    "Find app features",
                                    style: TextStyle(
                                        fontFamily: 'nunitoSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    _showDeleteConfirmationDialog(context, ref);
                  },
                  child: const Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.logout),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  fontFamily: 'nunitoSans',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          )),
    );
  }

  void _showZoomableImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            imageProvider: const AssetImage("image/ux.png"),
          ),
        );
      },
    );
  }

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
            "Are you sure you want to LogOut?",
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
                  ref.read(userSharedPrefsProvider).deleteUserToken();
                  ref.read(userSharedPrefsProvider).deleteUserDetails();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const GetStarted()),
                  );
                },
                child: const Text(
                  "Logout",
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
}
