import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/themes/theme.dart';
import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';
import 'package:momo_rating_app_frontend/screens/startings/splash_screen.dart';

enum FillingType { Chicken, Pork, Egg, Tofu, Paneer, Vegetables, Buff, Sea }

enum CookType { Steam, Fry, Jhol, Kothe, CMoMo }

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xffFFA70B),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: getApplicationTheme(false),
      home: const Profile(),
    );
  }
}

// class AutocompleteService {
//   final String apiKey;
//   final String apiUrl;

//   AutocompleteService({required this.apiKey, required this.apiUrl});

//   Future<List<Map<String, dynamic>>> fetchAutocompleteSuggestions(
//       String query) async {
//     final response = await http.get(
//       Uri.parse(
//           '$apiUrl/geocode/autocomplete?api_key=$apiKey&text=$query&boundary.rect.min_lon=80.0588&boundary.rect.min_lat=26.347&boundary.rect.max_lon=88.2015&boundary.rect.max_lat=30.4227'),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return (data['features'] as List)
//           .map<Map<String, dynamic>>((feature) => {
//                 'label': feature['properties']['label'],
//                 'name': feature['properties']['name'],
//                 'state': feature['properties']['state'],
//                 'country': feature['properties']['country'],
//               })
//           .toList();
//     } else {
//       throw Exception('Failed to load suggestions');
//     }
//   }
// }

// class AutocompleteExample extends StatefulWidget {
//   const AutocompleteExample({super.key});

//   @override
//   _AutocompleteExampleState createState() => _AutocompleteExampleState();
// }

// class _AutocompleteExampleState extends State<AutocompleteExample> {
//   final AutocompleteService autocompleteService = AutocompleteService(
//     apiKey: '5b3ce3597851110001cf6248e27dd441ba1c42f8b9d16c3310f3ada9',
//     apiUrl: 'https://api.openrouteservice.org',
//   );

//   List<Map<String, dynamic>> suggestions = [];
//   bool isLoading = false;

//   void fetchSuggestions(String query) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final results =
//           await autocompleteService.fetchAutocompleteSuggestions(query);
//       setState(() {
//         suggestions = results;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Autocomplete Example')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: fetchSuggestions,
//               decoration: const InputDecoration(
//                 labelText: 'Search for a location',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           if (isLoading) const CircularProgressIndicator(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: suggestions.length,
//               itemBuilder: (context, index) {
//                 final suggestion = suggestions[index];
//                 return ListTile(
//                   title: Text(suggestion['label']),
//                   subtitle: Text(
//                       '${suggestion['name']}, ${suggestion['state']}, ${suggestion['country']}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() => runApp(const MaterialApp(home: AutocompleteExample()));
