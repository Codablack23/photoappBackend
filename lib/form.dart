import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";

import 'package:photoapp_backend/firebase_actions.dart';
import 'package:photoapp_backend/helpers.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({Key? key}) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final TextEditingController _textController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String photoName = "";
  Uint8List pickedimage = Uint8List(0);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var file = await image.readAsBytes();
      setState(() {
        pickedimage = file;
      });
    } else {
      if (kDebugMode) {
        print("An Error Occurred");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Photo Name:",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _textController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: const InputDecoration(
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please fill out this field";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Photo:",
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: pickedimage.isNotEmpty
                ? Image.memory(
                    pickedimage,
                    fit: BoxFit.fill,
                  )
                : const Center(
                    child: Text(
                      "No Image Selected",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.grey[800],
                          textStyle: const TextStyle(color: Colors.white)),
                      onPressed: () {
                        pickImage();
                      },
                      child: const Text("Select Image"))),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.grey[800],
                          textStyle: const TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (_formkey.currentState!.validate() &&
                            pickedimage.isNotEmpty) {
                          FileDetail files = FileDetail(
                              _textController.value.text, pickedimage);
                          FirebaseActions.upload(
                              image: files.file,
                              name: files.name,
                              callBack: (success, err) {
                                if (err == null) {
                                  setState(() {
                                    _textController.clear();
                                    pickedimage = Uint8List(0);
                                  });
                                }
                              },
                              context: context);
                        } else {
                          if (pickedimage.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                'Please Choose a Photo ',
                                style: TextStyle(color: Colors.red),
                              )),
                            );
                          }
                        }
                      },
                      child: const Text("Upload"))),
            ],
          )
        ]));
  }
}
