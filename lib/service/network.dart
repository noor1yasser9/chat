import 'dart:convert';

import 'package:chat/model/NotificationModel.dart';
import 'package:chat/util/APIResponse.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  var BASE_URL = "";
  var headers = {
    "Authorization":
        "key=AAAAuOedmTI:APA91bFeK27sUs-Pdnfgdwwm1jEGYZBsfvZUkpXLzjKskVWPKEv0sF4gExcxSM3aJdGuVN89RVX4RodwjLrMW40IOpUkSEdodp1Nh7GJGVzpyep7mfoCD8l4SVM5SIJj4VXwWlaZX3yR",
    "Content-Type": "application/json"
  };

  Future<APIResponse<bool>> sendNotification(NotificationParent notificationModel) {
    print("data.statusCode sendNotification");
    return http
        .post(Uri.parse( "https://fcm.googleapis.com/fcm/send"),
            headers: headers,
            body: json.encode(NotificationParent.toJson(notificationModel)))
        .then((data) {
      print("data.statusCode ${data.statusCode}");
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) {
      APIResponse<bool>(error: true, errorMessage: 'An error occured');
      print("data.statusCode An error occured");
    });
  }
}
