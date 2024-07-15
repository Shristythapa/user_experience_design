import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/utils/auto_complete_service.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final List<FillingType> selectedFilling = [];
  final List<CookType> selectedCook = [];
  TextEditingController searchBarController = TextEditingController();

  final AutocompleteService autocompleteService = AutocompleteService(
    apiKey: '5b3ce3597851110001cf6248e27dd441ba1c42f8b9d16c3310f3ada9',
    apiUrl: 'https://api.openrouteservice.org',
  );

  List<Map<String, dynamic>> suggestions = [];
  bool isLoading = false;
  void fetchSuggestions(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final results =
          await autocompleteService.fetchAutocompleteSuggestions(query);
      setState(() {
        suggestions = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Search',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: searchBarController,
                          onChanged: fetchSuggestions,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search by place',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                        Visibility(
                          visible: suggestions.isNotEmpty,
                          child: SizedBox(
                            height: 200, // Adjust the height as needed
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = suggestions[index];
                                return ListTile(
                                  title: Text(suggestion['name']),
                                  // subtitle: Text(
                                  //     '${suggestion['name']} ${suggestion['label']}'),
                                  onTap: () {
                                    // Set the locationController's text to the selected suggestion
                                    searchBarController.text =
                                        suggestion['name'];
                                    // Clear suggestions
                                    setState(() {
                                      suggestions.clear();
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(moMoViewModelProvider.notifier).searchMomo(
                          context: context,
                          query: searchBarController.text,
                          filling: selectedFilling,
                          cook: selectedCook);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Search with Preference',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50),
              buildPreferenceSection<FillingType>(
                  'Filling', FillingType.values, selectedFilling),
              const SizedBox(height: 24),
              buildPreferenceSection<CookType>(
                  'Cook', CookType.values, selectedCook),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPreferenceSection<T>(
      String title, List<T> values, List<T> selectedValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            final isSelected = selectedValues.contains(value);
            return ChoiceChip(
              // elevation: !isSelected ? 2 : 2,
              label: Text(value.toString().split('.').last),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(value);
                  } else {
                    selectedValues.remove(value);
                  }
                });
              },
              selectedColor: Colors.amber,
              backgroundColor: const Color(0xffF1F1F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.amber : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(
          color: Color(0xffAEAEAE),
        )
      ],
    );
  }
}
