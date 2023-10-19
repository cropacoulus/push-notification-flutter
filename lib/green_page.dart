import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:push_notifications/services/auth_service.dart';
import 'package:push_notifications/services/database_service.dart';

class GreenPage extends StatefulWidget {
  const GreenPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GreenPage> createState() => _GreenPageState();
}

class _GreenPageState extends State<GreenPage> {
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (imagePath != null)
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                AuthServices.signInAnonymous();
              },
              child: Text('sign in'),
            ),
            ElevatedButton(
              onPressed: () async {
                XFile? xFile = await getImage();
                imagePath = await DatabaseService.uploadImage(xFile);
                print(imagePath);
                setState(() {});
              },
              child: Text(
                'Upload Image,',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<XFile?> getImage() async {
  ImagePicker image = ImagePicker();
  return await image.pickImage(source: ImageSource.gallery);
}
