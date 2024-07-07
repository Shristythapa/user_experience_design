import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutocompleteService {
  final String apiKey;
  final String apiUrl;

  AutocompleteService({required this.apiKey, required this.apiUrl});

  Future<List<Map<String, dynamic>>> fetchAutocompleteSuggestions(
      String query) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/geocode/autocomplete?api_key=$apiKey&text=$query&boundary.rect.min_lon=80.0588&boundary.rect.min_lat=26.347&boundary.rect.max_lon=88.2015&boundary.rect.max_lat=30.4227'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List)
          .map<Map<String, dynamic>>((feature) => {
                'label': feature['properties']['label'],
                'name': feature['properties']['name'],
                'state': feature['properties']['state'],
                'country': feature['properties']['country'],
              })
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
