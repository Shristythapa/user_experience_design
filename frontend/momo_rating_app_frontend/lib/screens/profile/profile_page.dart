import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/startings/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  // late bool isDark;
  @override
  void initState() {
    // isDark = ref.read(isDarkThemeProvider);
    _getUserDetails();
    super.initState();
  }

  late dynamic user; // Declare a variable to store the user information

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

  @override
  Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Profile Page"),
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
// // Delete the token from SharedPreferences
//                   ref.read(userSharedPrefsProvider).deleteUserToken();

//                   // Navigate to the GetStarted page
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (_) => const GetStarted()),
//                   );
//                 },
//                 child: const Text("Log out")),
//             Switch(
//                 value: isDark,
//                 onChanged: (value) {
//                   setState(() {
//                     isDark = value;
//                     ref.read(isDarkThemeProvider.notifier).updateTheme(value);
//                   });
//                 }),
//           ],
//         ),
//       ),
//     );

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
                      backgroundImage:
                          NetworkImage('${user['profileImageUrl']}'),
                      radius: 70,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          " ${user['userName']}",
                          style: const TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "${user['email']}",
                          style: const TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
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
                const Row(
                  children: [
                    Icon(Icons.heart_broken_outlined),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "Your Momo Preferences",
                              style: TextStyle(
                                  fontFamily: 'nunitoSans',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                          ],
                        ))
                  ],
                ),
                InkWell(
                  onTap: () async {
                    // Show confirmation dialog
                    bool confirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the dialog and return false (not confirmed)
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(userSharedPrefsProvider)
                                    .deleteUserToken();
                                ref
                                    .read(userSharedPrefsProvider)
                                    .deleteUserDetails();
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );

                    // Check if user confirmed logout
                    if (confirmed == true) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove("token");

                      // Navigate to the GetStarted page
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const GetStarted()),
                      );
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontFamily: 'nunitoSans',
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          )),
    );
  }
}
