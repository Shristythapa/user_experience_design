import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/utils/auto_complete_service.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/momo_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AddMoMo extends ConsumerStatefulWidget {
  const AddMoMo({super.key});

  @override
  ConsumerState<AddMoMo> createState() => _AddMoMoState();
}

class _AddMoMoState extends ConsumerState<AddMoMo> {
  TextEditingController locationController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? image;
  String? imagePath;
  String? imageUrl;
  final form = GlobalKey<FormState>();

  FillingType? selectedFillingType;
  CookType? selectedCookType;

  // Check for the camera permission
  double rating = 0;
  // Check for the camera permission
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;
  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) {
        // Set a default image path here
        const defaultImagePath = 'image/default_image.jpg';
        _img = File(defaultImagePath);
      } else {
        _img = File(image.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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
    int sizeOfMomo = 0;
    int aesthetics = 0;
    int priceValue = 0;
    int spicyLevel = 0;
    int sauceVariety = 0;
    int overallTaste = 0;
    final state = ref.watch(moMoViewModelProvider);
    TextEditingController review = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showMessage) {
        SnackBarManager.showSnackBar(
            message: state.message, context: context, isError: state.isError);
        ref.read(moMoViewModelProvider.notifier).resetState();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add MoMo",
            style: TextStyle(
                color: Color(0xff000000),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              if (state.isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  ),
                ),
              Center(
                child: Form(
                  key: form,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: const Color(0xFF6D3F83),
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        checkCameraPermission();
                                        _browseImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.camera),
                                      label: const Text('Camera'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _browseImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.image),
                                      label: const Text('Gallery'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: CircleAvatar(
                                radius: 50,
                                // backgroundImage:
                                //     AssetImage('assets/images/profile.png'),
                                backgroundImage: _img != null
                                    ? FileImage(_img!)
                                    : const AssetImage(
                                            'image/camera_icon_image.jpg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              controller: locationController,
                              onChanged: fetchSuggestions,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Location is invalid";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red[900]),
                                labelText: "Location",
                                prefixIcon: const Icon(Icons.location_on,
                                    color: Color(0xFF000000)),
                                labelStyle: const TextStyle(
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                border: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              keyboardType: TextInputType.text,
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
                                      subtitle: Text('${suggestion['lable']}'),
                                      onTap: () {
                                        // Set the locationController's text to the selected suggestion
                                        locationController.text =
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
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          controller: shopController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "shop name is invalid";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red[900]),
                            labelText: "shop",
                            prefixIcon: const Icon(Icons.home,
                                color: Color(0xFF000000)),
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
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          controller: priceController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "price is invalid";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red[900]),
                            labelText: "price",
                            prefixIcon: const Icon(Icons.currency_rupee,
                                color: Color(0xFF000000)),
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
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        buildPreferenceSection<FillingType>(
                          'Filling Type',
                          FillingType.values,
                          selectedFillingType,
                          (value) {
                            setState(() {
                              selectedFillingType = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        buildPreferenceSection<CookType>(
                          'Cook Type',
                          CookType.values,
                          selectedCookType,
                          (value) {
                            setState(() {
                              selectedCookType = value;
                            });
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
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          "Aesthetics",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        RatingBar.builder(
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          itemPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
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
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xff43B13A), // Change button color to red
                              ),
                              onPressed: () async {
                                if (form.currentState!.validate()) {
                                  var userId = await ref
                                      .read(userSharedPrefsProvider)
                                      .getUserDetails();
                                  userId.fold((l) {
                                    return SnackBarManager.showSnackBar(
                                        isError: true,
                                        message: "User not found",
                                        context: context);
                                  }, (r) {
                                    if (selectedFillingType == null ||
                                        selectedCookType == null) {
                                      return SnackBarManager.showSnackBar(
                                          isError: true,
                                          message:
                                              "Filling and Cook type is required",
                                          context: context);
                                    }
                                    MoMoApiModel moApiModel = MoMoApiModel(
                                        userId: r['_id'],
                                        momoPrice: priceController.text,
                                        cookType: selectedCookType.toString(),
                                        fillingType:
                                            selectedFillingType.toString(),
                                        location: locationController.text,
                                        shop: shopController.text);

                                    ref
                                        .read(moMoViewModelProvider.notifier)
                                        .addMoMo(
                                          image: _img,
                                          moMoApiModel: moApiModel,
                                          userId: r['_id'],
                                          overallRating: overallTaste,
                                          fillingAmount: 1,
                                          sizeOfMomo: sizeOfMomo,
                                          sauceVariety: sauceVariety,
                                          aesthetic: aesthetics,
                                          spiceLevel: spicyLevel,
                                          priceValue: priceValue,
                                          textReview: review.text,
                                          context: context,
                                        );
                                  });
                                }
                              },
                              child: const Text("add momo")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPreferenceSection<T>(String title, List<T> values,
      T? selectedValue, void Function(T?) onValueChanged) {
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
            final isSelected = value == selectedValue;
            return ChoiceChip(
              label: Text(value.toString().split('.').last),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    onValueChanged(value);
                  } else {
                    onValueChanged(null);
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

  Widget buildRating() => RatingBar.builder(
        minRating: 0,
        maxRating: 5,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          this.rating = rating;
        },
      );
}

Widget bottomSheet(BuildContext context) {
  // Size size = MediaQuery.of(context).size;

  return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      height: 200,
      child: Column(
        children: [
          const Text("Choose Profile Photo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: const Column(
                  children: [
                    Icon(Icons.image),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Gallary",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(
                width: 80,
              ),
              InkWell(
                onTap: (() {}),
                child: const Column(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Camera",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ));
}
