import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    _prefs.then((value) {
      image = value.getString("image");
      nameController.text = value.getString("name");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Data"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(32),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: Material(
                    child: avatarImageFile == null
                        ? photoUrl.isNotEmpty
                            ? Material(
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  width: 90.0,
                                  height: 90.0,
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 90.0,
                                      color: Colors.grey,
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 90.0,
                                      height: 90.0,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 90.0,
                                color: Colors.grey,
                              )
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Text(
                        'Full Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.blue),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Sweetie',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          controller: nameController,
                          onChanged: (value) {
                            // nickname = value;
                          },
                          // focusNode: focusNodeNickname,
                        ),
                      ),
                      margin: EdgeInsets.only(right: 30.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // <-- Button color
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      child: Text('Update'),
                    ),
                    onPressed: () {
                      handleUpdateData();
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  var image = "";

  final TextEditingController nameController = TextEditingController();
  String id = FirebaseAuth.instance.currentUser.uid;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String photoUrl = '';
  File avatarImageFile;

  Future uploadFile() async {
    Reference reference = FirebaseStorage.instance.ref().child(id);
    UploadTask uploadTask = reference.putFile(avatarImageFile);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('Users').doc(id).update(
          {'name': nameController.text, 'image': photoUrl}).then((data) async {
        _prefs.then((value) {
          value.setString('image', photoUrl);
        });
        Fluttertoast.showToast(msg: "Upload success");
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker
        .getImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
      });
    }
  }

  void handleUpdateData() {
    if (avatarImageFile != null) uploadFile();

    FirebaseFirestore.instance.collection('Users').doc(id).update(
        {'name': nameController.text, 'image': image}).then((data) async {
      _prefs.then((value) {
        value.setString('name', nameController.text);
        value.setString('image', photoUrl);
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    Get.back();
  }
}
