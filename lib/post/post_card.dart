import 'package:flutter/material.dart';
import 'package:photois/model/post_model.dart';
import 'package:photois/post/post_info.dart';
import '../Main/data.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  final PostModel data;
  final double size;

  PostCard({super.key, required this.data, required this.size});

  final sizeController = Get.put((SizeController()));
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black.withOpacity(0.2),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoInfo(data: data),
          ),
        );
      },
      child: Ink(
        child: Stack(
          children: [
            SizedBox(
              height: size,
              width: size,
              child: Image.network(
                data.imageURL ?? 'No imageURL',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${data.address}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: sizeController.middleFontSize.value * 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_outlined,
                      color: Colors.deepOrange,
                    ),
                    Text(
                      " ${data.likes.userIDs.length}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: sizeController.middleFontSize.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
