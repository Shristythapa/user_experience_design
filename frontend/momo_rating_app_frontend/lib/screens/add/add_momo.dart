import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momo_rating_app_frontend/core/utils/cook_filter_chip.dart';
import 'package:momo_rating_app_frontend/core/utils/filling_filter_chip.dart';
import 'package:momo_rating_app_frontend/core/utils/filtered_chip.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/viewmodel/momo_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AddMoMo extends ConsumerStatefulWidget {
  const AddMoMo({super.key});

  @override
  ConsumerState<AddMoMo> createState() => _AddMoMoState();
}

class _AddMoMoState extends ConsumerState<AddMoMo> {
  TextEditingController momoTitleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? image;
  String? imagePath;
  String? imageUrl;
  final form = GlobalKey<FormState>();

  Set<Dite> diteFilters = {};
  Set<FillingType> fillingFilters = {};
  Set<CookType> cookFilters = {};
  // Check for the camera permission

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(MoMoViewModelProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add MoMo",
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios_rounded))
            ],
          ),
          body: Center(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        'image/dummyProfileImage.jfif')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      controller: momoTitleController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Momo title is invalid";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red[900]),
                        labelText: "momo title",
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      controller: locationController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "location is invalid";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red[900]),
                        labelText: "location",
                        prefixIcon: const Icon(Icons.location_on,
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
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
                        prefixIcon:
                            const Icon(Icons.home, color: Color(0xFF000000)),
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
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
                    FilterChipExample(
                      filters: diteFilters,
                      onSelectionChanged: (Set<Dite> dite) {
                        diteFilters = dite;
                      },
                    ),
                    FillingFilterChipExample(
                      filters: fillingFilters,
                      onSelectionChanged: (Set<FillingType> filling) {
                        fillingFilters = filling;
                      },
                    ),
                    CookFilterChipExample(
                      filters: cookFilters,
                      onSelectionChanged: (Set<CookType> selectedFilters) {
                        cookFilters = selectedFilters;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          MoMoApiModel moApiModel = MoMoApiModel(
                              userId: "662d6ee75ebfcbe26cb37909",
                              momoName: momoTitleController.text,
                              momoPrice: priceController.text,
                              cookType: cookFilters.toString(),
                              fillingType: fillingFilters.toString(),
                              location: locationController.text);

                          ref
                              .read(MoMoViewModelProvider.notifier)
                              .addMoMo(_img!, moApiModel, context);
                        },
                        child: const Text("add momo"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
