class NotificationParent {
  NotificationModel data;
  String to;

  NotificationParent(this.data, this.to);

  static Map<String, dynamic> toJson(NotificationParent item) {
    var details = new Map<String, dynamic>();
    details["to"] = item.to;
    details['data'] =
        NotificationModel.toJson(item.data);
    return details;
  }
}

class NotificationModel {
  String name;
  String message;
  String path;


  NotificationModel(this.name, this.message, this.path);

  static Map<String, dynamic> toJson(NotificationModel item) {
    var details = new Map<String, dynamic>();
    details["name"] = item.name;
    details['message'] = item.message;
    details['path'] = item.path;
    return details;
  }
}
