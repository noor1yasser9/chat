import 'package:chat/model/users.dart';
import 'package:chat/ui/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItem extends StatelessWidget {
  final UserData userData;

  UserItem({this.userData});

  @override
  Widget build(BuildContext context) {
    print("tttttttt ${userData.image}");
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(ChatScreen(userData));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: Material(
                    child: Image.network(
                      userData.image,
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 50.0,
                          height: 50.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes !=
                                          null &&
                                      loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
            trailing: Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: userData.isOnline?Colors.green:Colors.blueGrey),
            ),
            title: Text(userData.name),
            subtitle: Text('${userData.email} '),
          ),
        ),
      ),
    );
  }
}
