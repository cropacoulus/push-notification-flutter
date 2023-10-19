import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  static Future<void> createOrUpdateProduct(String id, {String? name, int? price}) async {
    await productCollection.doc(id).set({
      'name': name,
      'price': price,
    });
  }

  static Future<DocumentSnapshot> getProduct(String id) async {
    return await productCollection.doc(id).get();
  }

  static Future<void> deleteProduct(String id) async {
    await productCollection.doc(id).delete();
  }

  static Future<String> uploadImage(XFile? imageFile) async {
    String fileName = basename(imageFile!.path); // get the file name
    String url = '';

    //XFile get the reference to the storage

    Reference ref = FirebaseStorage.instance.ref().child(fileName); // get the reference to the storage

    //upload the image to the storage xfile

    File fileImage = File(imageFile.path);

    UploadTask task = ref.putFile(fileImage); // upload the file to the storage

    url = await (await task).ref.getDownloadURL(); // get the url of the image
    print('ini url $url');
    return url;
  }
}
