import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class RedPage extends StatefulWidget {
  const RedPage({Key? key}) : super(key: key);

  @override
  State<RedPage> createState() => _RedPageState();
}

class _RedPageState extends State<RedPage> {
  final _imagePicker = ImagePicker();
  File? imageFile;
  String? image;
  String url = 'http://192.168.77.29:4000/uploads/';

  Future uploadImage() async {
    try {
      var response = await Dio().post(
        'http://192.168.77.29:4000/api/upload',
        data: FormData.fromMap({
          'name': 'test',
          'image': await MultipartFile.fromFile(imageFile!.path),
        }),
      );
      setState(() {
        image = response.data['image'];
      });
    } catch (e) {
      throw Exception(e.toString());
    }

    // // get the url of the image
    // return response.data['image'];
  }

  Future fetchImage() async {
    try {
      var response = await Dio().get(
        'http://192.168.77.29:4000/api/upload',
      );

      print('ini url ${response.data['image']}');
    } catch (e) {
      print(e.toString());
    }
  }

  Future upload() async {
    XFile? xFile = await getImage();
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile.path);
      });
    }
    await uploadImage();
    fetchImage();
  }

  Future<XFile?> getImage() async {
    return await _imagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (image != null)
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(url+image!),
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
                upload();
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
