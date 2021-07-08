import 'package:chat/items/UserItem.dart';
import 'package:chat/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final firestoreInstance = FirebaseFirestore.instance;

  // create user obj based on firebase user

  Future<dynamic> updateUserData(UserData userData) async {
    await firestoreInstance.collection('Users').doc(userData.uid).set({
      'email': userData.email,
      'uid': userData.uid,
      'name': userData.name,
      'image': '',
      'isOnline': false,
      'token': ''
    }).then((value) {
      return value;
    });
  }

// // brew list from snapshot

}
