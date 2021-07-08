import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:chat/util/extension.dart';
import 'package:get/get.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(child: PhotoView(imageProvider: NetworkImage(url))),
            Positioned(
              top: 30,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: "#A1B49F".toColor(),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
