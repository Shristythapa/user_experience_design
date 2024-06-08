// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// final notificationViewModelProvider =
//     Provider((ref) => NotificationViewModel());

// class NotificationViewModel {
//   void requestPermission() async {
//     final FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted Permission");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print("User granted provisional permission");
//     } else {
//       print("User declined or nas not accepeted permission");
//     }
//   }

//   void getToken(String sessionId) async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       saveToken(token!, sessionId);
//     });
//   }

//   Future<String?> getUserToken(String sessionId) async {
//     DocumentReference documentReference =
//         FirebaseFirestore.instance.collection("UserTokens").doc(sessionId);
//     try {
//       DocumentSnapshot snapshot = await documentReference.get();
//       if (snapshot.exists) {
//         var data = snapshot.data()
//             as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
//         if (data != null) {
//           var token = data['token']; // Access token using the [] operator
//           return token;
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       print('Error retrieving data: $error');
//       return null;
//     }
//   }

//   void saveToken(String token, String sessionId) async {
//     await FirebaseFirestore.instance
//         .collection("UserTokens")
//         .doc(sessionId)
//         .set({'token': token});
//   }

//   Future<void> sendPushMessage(String token, String body, String title) async {
//     print("sendingggg...$token, body: $body, title: $title,");
//     try {
//       await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Authorization':
//                 'key=AAAAqerK01w:APA91bG1-VE5M5Xx9W9x_GTA-zrNhDoXHuJfqMcBP2HPLQpkV3aTTZICIj9VGxj3xP9rdOsVWHvSVzjLJOHKKh0LDsgvvQLg2t6_Pai_aCEyiNl8ELsnb7iujryKxMjf1QZM1u6yxjDi'
//           },
//           body: jsonEncode(<String, dynamic>{
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'status': 'done',
//               'body': body,
//               'title': title
//             },
//             "notification": <String, dynamic>{
//               "title": title,
//               "body": body,
//               "android_channel_id": "dbfood"
//             },
//             "to": token
//           }));
//     } catch (e) {
//       print("Notification send error $e");
//     }
//   }
// }
