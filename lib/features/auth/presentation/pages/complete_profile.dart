import 'dart:io';

import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CProfile extends StatefulWidget {
  final UserModel uModel;
  final User firebaseUser;
  const CProfile({
    Key? key,
    required this.uModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<CProfile> createState() => _CProfileState();
}

class _CProfileState extends State<CProfile> {
  File? imgFile;
  TextEditingController fController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? imgFile = await ImagePicker().pickImage(source: source);
    if (imgFile != null) {
      cropImage(imgFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );
    if (cropImage != null) {
      setState(() {
        File cropFile = File(cropImage.path);
        imgFile = cropFile;
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Choose an Option"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  title: const Text("Select form Gallery"),
                  leading: const Icon(Icons.photo_album),
                ),
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  title: const Text("Take a photo"),
                  leading: const Icon(Icons.camera_alt_outlined),
                ),
              ]),
            ));
  }

  void checkValues() {
    String fullName = fController.text;
    if (fullName == "" || imgFile == null) {
      print("please fill all the fields");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.uModel.uId.toString())
        .putFile(imgFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fController.text;

    widget.uModel.fullName = fullName;
    widget.uModel.profilePic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uModel.uId)
        .set(widget.uModel.toMap())
        .then((value) => print("Data Uploaded"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imgFile != null ? FileImage(imgFile!) : null,
                  child: (imgFile == null) ? const Icon(Icons.person) : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CusForm(
                hintText: "Full Name",
                textEditingController: fController,
              ),
              const SizedBox(
                height: 50,
              ),
              CusButton(
                text: "Submit",
                loaded: true,
                height: 60,
                width: 120,
                onTap: () async{
                   await Future.delayed(const Duration(seconds: 3));
                  checkValues();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
