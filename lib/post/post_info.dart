import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/intl.dart';
import '../Main/data.dart' as my_data;
import 'package:get/get.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';
import '../style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoInfo extends StatefulWidget {
  final PostModel data;

  const PhotoInfo({super.key, required this.data});

  @override
  State<PhotoInfo> createState() => _PhotoInfoState();
}

class _PhotoInfoState extends State<PhotoInfo> {
  late PostModel data;
  final sizeController = Get.put((my_data.SizeController()));
  final controller = Get.put(my_data.UserInfo());
  bool isFavorite = false;
  int isReportSelected = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  NaverMapController? _controller;
  late NMarker marker;
  String uid = '';
  String instagramID = '';
  String nickName = '';

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
    uid = auth.currentUser!.uid;
    if (data.likes.contains(uid)) {
      isFavorite = true;
    }
    loadData();
  }

  Future<void> loadData() async {
    var result = await firestore.collection('userInfo').doc(data.userUid).get();
    instagramID = result.data()!['phoneNumber'];
    nickName = result.data()!['nickname'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final String uid = auth.currentUser!.uid;
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
            color: AppColor.objectColor,
            onSelected: (value) {
              if (value == 'report') {
                _reportConfirmDialog(context);
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

              if (data.userUid == uid) {
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
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        nickName,
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: sizeController.mainFontSize.value + 2,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        instagramID == '' ? "" : "@${instagramID}",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat("yyyy년 MM월 dd일 H:m  ")
                        .format(data.date!.toDate()),
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value,
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
                            final likes = data.likes;
                            if (isFavorite) {
                              likes.remove(uid);
                            } else {
                              likes.add(uid);
                            }
                            PostModel updatePost = PostModel(
                              postState: data.postState,
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
                              likes: likes,
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
                        "${data.likes.length} Likes",
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
            '신고!',
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.backgroundColor),
          ),
          content: Text(
            '해당 글을 신고하시겠습니까?',
            style: TextStyle(
                fontSize: sizeController.middleFontSize.value,
                fontWeight: FontWeight.w500,
                color: AppColor.backgroundColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                _reportContextDialog(context);
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

  void _reportContextDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.objectColor,
          title: Text(
            '신고!',
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.backgroundColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어떤 이유로 해당 글을 신고하시겠습니까?\n버튼을 누르시면 해당 게시물이 내려가며\n바로 신고됩니다.',
                style: TextStyle(
                  fontSize: sizeController.middleFontSize.value - 2,
                  fontWeight: FontWeight.w500,
                  color: AppColor.backgroundColor,
                ),
              ),
              SizedBox(height: sizeController.screenHeight.value * 0.02),
              TextButton(
                onPressed: () {
                  report('게시물이 적합하지 않음');
                },
                child: Text(
                  '게시물이 적합하지 않음',
                  style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  report('인스타그램 정보 도용');
                },
                child: Text(
                  '인스타그램 정보 도용',
                  style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  report('유해한 사진 및 게시글');
                },
                child: Text(
                  '유해한 사진 및 게시글',
                  style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  report('기타');
                },
                child: Text(
                  '기타',
                  style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          actions: [
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

  void report(String report) {
    PostModel updatePost = PostModel(
      postState: false,
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
      likes: data.likes,
      likesCount: data.likesCount,
      report: report,
      reference: data.reference,
    );
    FireService().updatePost(
        reference: updatePost.reference!, json: updatePost.toJson());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('신고 완료'),
    ));
    Get.back();
    Get.back();
  }
}
