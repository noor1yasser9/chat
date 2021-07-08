import 'package:chat/model/users.dart';
import 'package:chat/service/DatabaseService%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/model/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService();

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      prefs.setString("uid", user.uid);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        prefs.setString("name", value.data()["name"]);
        prefs.setString("email", value.data()["email"]);
        prefs.setString("image", value.data()["email"] ?? '');

        print("tttttttttt saf ${value.data()}");
      });
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      UserData userData, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: userData.email, password: password);
      final user = result.user;
      // create a new document for the user with the uid
      userData.uid = user.uid;
      print("asdfas ${user.uid}");
      await DatabaseService(uid: user.uid)
          .updateUserData(userData)
          .then((values) {
        if (values != null) {
          return user;
        } else {
          return null;
        }
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
