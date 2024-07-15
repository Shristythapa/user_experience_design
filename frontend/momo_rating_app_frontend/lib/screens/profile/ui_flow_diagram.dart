import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/screens/profile/profile_page.dart';
import 'package:photo_view/photo_view.dart';

class UiFlowDiagram extends StatelessWidget {
  const UiFlowDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
            );
          },
        ),
      ]),
      body: PhotoView(
        imageProvider: const AssetImage('image/ux.png'),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
