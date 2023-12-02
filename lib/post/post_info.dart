import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Main/data.dart';
import 'package:get/get.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';
import '../style/weather_icon.dart';

class PhotoInfo extends StatefulWidget {
  final PostModel data;

  const PhotoInfo({super.key, required this.data});

  @override
  State<PhotoInfo> createState() => _PhotoInfoState();
}

class _PhotoInfoState extends State<PhotoInfo> {
  late PostModel data;
  final sizeController = Get.put((SizeController()));
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    if (data.likes.userIDs.contains('jin')) {
      isFavorite = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('게시물'),
        leading: IconButton(
          onPressed: () {
            Get.offNamed('/main');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: sizeController.screenWidth.value,
                  width: double.infinity,
                  child: Image.network(
                    data.imageURL ?? 'No imageURL',
                    fit: BoxFit.cover,
                  ),
                ),

                ///TODO: 인스타정보 불러오기
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "@jingjing_2_",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: sizeController.middleFontSize.value,
                      ),
                    ),
                  ),
                )
                /*
                  Visibility(
                    visible:
                    child: Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          " ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: sizeController.middleFontSize.value,
                          ),
                        ),
                      ),
                    ),
                  )
                   */
              ],
            ), //받아온 게시물 이미지 넣기
            SizedBox(
              height: sizeController.screenHeight * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            final likes = data.likes.userIDs;
                            if (isFavorite) {
                              likes.remove('jin');
                            } else {
                              likes.add('jin');
                            }
                            PostModel updatePost = PostModel(
                              postID: data.postID,
                              createdAt: data.createdAt,
                              userUid: data.userUid,
                              imageURL: data.imageURL,
                              address: data.address,
                              longitude: data.longitude,
                              latitude: data.latitude,
                              date: data.date,
                              weather: data.weather,
                              category: data.category,
                              likes: LikeModel(userIDs: likes),
                              reference: data.reference,
                            );
                            FireService().updatePost(
                                reference: updatePost.reference!,
                                json: updatePost.toJson());
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          icon: isFavorite
                              ? const Icon(Icons.favorite_outlined,
                                  color: Colors.red, size: 30)
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 30,
                                )),
                      Text("${data.likes.userIDs.length} Likes",
                          style: TextStyle(
                              fontSize: sizeController.mainFontSize.value)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                              DateFormat("yyyy년 MM월 dd일 H:m  ")
                                  .format(data.date!.toDate()),
                              style: TextStyle(
                                  fontSize:
                                      sizeController.middleFontSize.value)),
                          Icon(getWeatherIcon(data.weather)),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.05,
                          )
                        ],
                      ),
                      Text("CATEGORY: ${data.category!.title}",
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(height: sizeController.screenHeight.value * 0.3),

            ///TODO: 글 정보 불러오기
            const Divider(),
            SizedBox(height: sizeController.screenHeight.value * 0.02),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data.address ?? 'No address',
                  style:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
            ),

            ///TODO: 맵 정보 띄우기
            SizedBox(
              height: sizeController.screenWidth.value * 0.8,
              width: double.infinity,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FzakEUsma5ZFzdojmEHbo%2Fc6fabe925d0592e219433bb60619b5122c12871aMap.png?alt=media&token=38de594f-df1d-42b7-8eef-c66212f64d07',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: sizeController.screenHeight.value * 0.1),
          ],
        ),
      ),
    );
  }

  IconData getWeatherIcon(PostWeather? weather) {
    switch (weather) {
      case PostWeather.sun:
        return WeatherIcon.sun;
      case PostWeather.cloud:
        return WeatherIcon.cloud;
      case PostWeather.rain:
        return WeatherIcon.rain;
      case PostWeather.snow:
        return WeatherIcon.snow;
      default:
        return WeatherIcon.sun;
    }
  }
}
