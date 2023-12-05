import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/intl.dart';
import '../Main/data.dart';
import 'package:get/get.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';
import '../style/style.dart';

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

  NaverMapController? _controller;
  late NMarker marker;

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "ud3er0cxg6",
    "X-NCP-APIGW-API-KEY": "i5bTtbxYq6VpOvNCYN4A6Qlw8hDzAdFKw0AsEk6s"
  };

  double lat = 0;
  double lng = 0;

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
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        title: Center(
          child: Text(
            "ABOUT POST",
            style: TextStyle(
                fontSize: sizeController.bigFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.textColor),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColor.objectColor,
            )),
        actions: [
          PopupMenuButton<String>(
            iconColor: AppColor.objectColor,
            color: AppColor.objectColor,
            onSelected: (value) {
              if (value == 'report') {
                print('신고');
              } else if (value == 'delete') {
                _deleteConfirmDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuItems = [];
              menuItems.add(
                PopupMenuItem<String>(
                  value: 'report',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.report_problem,
                        size: 25,
                        color: Colors.deepOrangeAccent,
                      ),
                      Text(
                        "   신고",
                        style: TextStyle(
                          fontSize: sizeController.middleFontSize.value,
                          fontWeight: FontWeight.w600,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );

              // TODO: userUID 집어넣기
              if (data.userUid == 'jin') {
                menuItems.add(
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.deepOrangeAccent,
                        ),
                        Text(
                          "   삭제",
                          style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w600,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return menuItems;
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///TODO: 인스타정보 불러오기
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@jingjing_2_ 님의 게시물",
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: sizeController.middleFontSize.value + 1,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat("yyyy년 MM월 dd일 H:m  ")
                        .format(data.date!.toDate()),
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value - 2,
                        fontWeight: FontWeight.w300,
                        color: AppColor.textColor),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: sizeController.screenWidth.value * 1.25,
                  width: sizeController.screenWidth.value,
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
                    color: AppColor.backgroundColor.withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data.mainAddress}",
                                style: TextStyle(
                                    fontSize:
                                        sizeController.mainFontSize.value + 3,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.textColor),
                              ),
                              Text(
                                "${data.extraAddress}",
                                style: TextStyle(
                                    fontSize:
                                        sizeController.middleFontSize.value - 3,
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeController.screenHeight * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              postState: data.postState,
                              postID: data.postID,
                              createdAt: data.createdAt,
                              userUid: data.userUid,
                              imageURL: data.imageURL,
                              mainAddress: data.mainAddress,
                              extraAddress: data.extraAddress,
                              content: data.content,
                              longitude: data.longitude,
                              latitude: data.latitude,
                              date: data.date,
                              weather: data.weather,
                              category: data.category,
                              likes: LikeModel(userIDs: likes),
                              likesCount: likes.length,
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
                                  color: AppColor.textColor,
                                  size: 30,
                                )),
                      Text(
                        "${data.likes.userIDs.length} Likes",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w300,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "#${data.weather!.title}# ${data.category!.title}",
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w400,
                            color: AppColor.textColor)),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColor.objectColor, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: data.content != ''
                  ? Text("${data.content}",
                      style: TextStyle(
                          fontSize: sizeController.middleFontSize.value,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textColor))
                  : Text("더보기",
                      style: TextStyle(
                          fontSize: sizeController.middleFontSize.value,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textColor)),
            ),
            const Divider(color: AppColor.objectColor, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${data.extraAddress}",
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textColor)),
            ),

            Center(
              child: SizedBox(
                height: sizeController.screenWidth.value * 0.95,
                width: sizeController.screenWidth.value * 0.95,
                child: FutureBuilder(
                  future: Future.value(true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      lat = data.latitude!;
                      lng = data.longitude!;

                      final cameraPosition = NCameraPosition(
                        target: NLatLng(lat, lng),
                        zoom: 15,
                        bearing: 0,
                        tilt: 0,
                      );
                      return NaverMap(
                        options: NaverMapViewOptions(
                          scaleBarEnable: true,
                          locationButtonEnable: false,
                          logoClickEnable: false,
                          extent: const NLatLngBounds(
                            southWest: NLatLng(31.43, 122.37),
                            northEast: NLatLng(44.35, 132.0),
                          ),
                          initialCameraPosition: cameraPosition,
                        ),
                        onMapReady: (controller) async {
                          _controller = controller;

                          final iconImage = await NOverlayImage.fromWidget(
                            widget: const Icon(Icons.place,
                                size: 32, color: AppColor.backgroundColor),
                            size: const Size(32, 32),
                            context: context,
                          );

                          marker = NMarker(
                            id: 'which',
                            position: NLatLng(lat, lng),
                            icon: iconImage,
                          );

                          _controller?.addOverlay(marker);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: sizeController.screenHeight.value * 0.2),

            SizedBox(height: sizeController.screenHeight.value * 0.2),
          ],
        ),
      ),
    );
  }

  void _deleteConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.objectColor,
          title: Text(
            '경고!',
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.backgroundColor),
          ),
          content: Text(
            '해당 사진 명소를 삭제하시겠습니까?\n복구는 불가능합니다.',
            style: TextStyle(
                fontSize: sizeController.middleFontSize.value,
                fontWeight: FontWeight.w500,
                color: AppColor.backgroundColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FireService().delPost(data.reference!);
                Get.back();
                Get.back();
              },
              child: Text(
                '확인',
                style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소',
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w600,
                      color: AppColor.backgroundColor)),
            ),
          ],
        );
      },
    );
  }

  void _reportConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.objectColor,
          title: Text(
            '경고!',
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.backgroundColor),
          ),
          content: Text(
            '돌아가시겠습니까?\n작성 중인 글은 저장되지 않습니다.',
            style: TextStyle(
                fontSize: sizeController.middleFontSize.value,
                fontWeight: FontWeight.w500,
                color: AppColor.backgroundColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text(
                '확인',
                style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소',
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w600,
                      color: AppColor.backgroundColor)),
            ),
          ],
        );
      },
    );
  }
}
