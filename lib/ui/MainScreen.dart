import 'package:chat/model/users.dart';
import 'package:chat/service/auth.dart';
import 'package:chat/ui/LoginScreen.dart';
import 'package:chat/ui/SignUpScreen.dart';
import 'package:chat/ui/UserListScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final SharedPreferences preferences;

  MainScreen({this.preferences});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthService get service => GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) return UserListScreen();
    return LoginScreen(
      preferences: widget.preferences,
    );
  }

}
