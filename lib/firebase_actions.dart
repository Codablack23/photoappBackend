import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photoapp_backend/helpers.dart';

class FirebaseActions {
  static Future<void> upload(
      {required Uint8List image,
      required String name,
      callBack,
      required BuildContext context}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final metaData = SettableMetadata(contentType: "image/jpeg");
    final photosRef = storageRef.child("photos/$name");
    final progress = photosRef.putData(image, metaData);

    progress.snapshotEvents.listen((TaskSnapshot snapshot) async {
      switch (snapshot.state) {
        case TaskState.running:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading')),
          );
          break;
        case TaskState.paused:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading has been Paused')),
          );
          break;
        case TaskState.error:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An Error Occured')),
          );
          callBack(null, "an error occurred");
          break;
        case TaskState.success:
          String url = await photosRef.getDownloadURL();
          FirebaseActions().uploadFile(
              name: name, url: url, context: context, callBack: callBack);

          break;
        default:
      }
    });
  }

  Future uploadFile(
      {required String name,
      callBack,
      required String url,
      required BuildContext context}) async {
    var db = FirebaseFirestore.instance;

    Map<String, String> uploadFile = {"name": name, "file_path": url};
    Helpers.debugPrint(uploadFile);
    db.collection("uploads").add(uploadFile).then((DocumentReference doc) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$name Uploaded Successfully')));
      callBack("success", null);
    });
  }
}
