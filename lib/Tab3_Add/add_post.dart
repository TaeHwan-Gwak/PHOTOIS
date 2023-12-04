import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photois/Main/data.dart';

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';

import 'package:photois/model/post_model.dart';
import 'package:photois/style/style.dart';
import '../getWeather.dart';
import '../service/post_api_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../style/weather_icon.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  final controller = Get.put((PhotoSpotInfo()));
  final sizeController = Get.put((SizeController()));
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  int selectedIconNum = 0;
  List<String> weather = ['sun', 'cloud', 'rain', 'snow'];
  List<String> category = ['solo', 'couple', 'friend', 'family'];
  bool clickWeatherButton = false;
  bool clickImageButton = false;
  bool clickInfoButton = false;

  final picker = ImagePicker();
  String? imageDownLoadURL;

  XFile? pickedFile;
  Exif? exif;
  Map<String, Object>? attributes;
  DateTime? shootingDate;
  ExifLatLong? coordinates;
  ScrollController _scrollController = ScrollController();

  void scrollToPosition(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    controller.printInfo();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

    exif = await Exif.fromPath(pickedFile!.path);
    attributes = await exif!.getAttributes();
    shootingDate = await exif!.getOriginalDate();
    coordinates = await exif!.getLatLong();

    setState(() {
      if (pickedFile != null) {
        if (int.parse(DateFormat.H().format(shootingDate!)) > 12) {
          controller.spotTimeHour.value =
              int.parse(DateFormat.H().format(shootingDate!)) - 12;
          controller.spotTimePeriod = [false, true];
        } else {
          controller.spotTimeHour.value =
              int.parse(DateFormat.H().format(shootingDate!));
        }
        controller.spotTimeMinute.value =
            int.parse(DateFormat.m().format(shootingDate!));
        controller.checkPickedFile.value = true;
        controller.spotDate.value = shootingDate!;
        controller.spotLongitude.value = coordinates!.longitude;
        controller.spotLatitude.value = coordinates!.latitude;
      }
    });
  }

  Future closeImage() async {
    await exif?.close();
    shootingDate = null;
    attributes = {};
    exif = null;
    coordinates = null;

    setState(() {});
  }

  Future<void> _uploadImage() async {
    if (pickedFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/${DateTime.now()}.jpg");
      UploadTask uploadTask = storageReference.putFile(File(pickedFile!.path));

      await uploadTask.whenComplete(() async {
        imageDownLoadURL = await storageReference.getDownloadURL();
        print(
            'Image uploaded to Firebase Storage , Download URL: $imageDownLoadURL');
      });
    } else {
      print('No image selected.');
    }
  }

  Widget _buildPhotoArea() {
    return pickedFile != null
        ? (clickImageButton
            ? SizedBox(
                width: sizeController.screenWidth.value * 0.7,
                height: sizeController.screenWidth.value * 0.7 * 1.25,
                child: Image.file(
                  File(pickedFile!.path),
                  fit: BoxFit.cover,
                ), //가져온 이미지를 화면에 띄워주는 코드
              )
            : InkWell(
                onTap: getImage,
                child: SizedBox(
                  width: sizeController.screenWidth.value,
                  height: sizeController.screenWidth.value * 1.25,
                  child: Image.file(
                    File(pickedFile!.path),
                    fit: BoxFit.cover,
                  ), //가져온 이미지를 화면에 띄워주는 코드
                ),
              ))
        : InkWell(
            onTap: getImage,
            child: Icon(
              Icons.add_box_rounded,
              size: sizeController.screenWidth.value,
              color: AppColor.objectColor,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          title: Center(
            child: Text(
              "NEW POST",
              style: TextStyle(
                  fontSize: sizeController.bigFontSize.value,
                  fontWeight: FontWeight.w900,
                  color: AppColor.textColor),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                _goBackConfirmDialog(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
                color: AppColor.objectColor,
              )),
          actions: [
            TextButton(
              onPressed: () {
                if (pickedFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진을 업로드해주세요'),
                  ));
                } else if (!clickImageButton) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('버튼을 눌러 사진 명소 정보를 입력해주세요'),
                  ));
                } else if (!clickInfoButton &&
                    !_formKey1.currentState!.validate()) {
                  scrollToPosition(400);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진 명소를 입력해주세요'),
                  ));
                } else if (!clickInfoButton) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('버튼을 눌러 부가 정보를 불러와주세요'),
                  ));
                  scrollToPosition(600);
                } else if (!_formKey1.currentState!.validate()) {
                  scrollToPosition(400);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진 명소를 입력해주세요'),
                  ));
                } else if (controller.spotExtraAddress.value == '' ||
                    controller.spotDate.value == DateTime(0, 0, 0, 0, 0)) {
                  scrollToPosition(800);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('위치 및 시간 정보 입력을 완료해주십시오'),
                  ));
                } else if (controller.spotWeather.value == 0) {
                  scrollToPosition(1200);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('날씨 정보 입력을 완료해주십시오'),
                  ));
                } else if (controller.spotCategory.value == 0) {
                  scrollToPosition(1600);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('카테고리 입력을 완료해주십시오'),
                  ));
                } else {
                  _postConfirmDialog(context);
                }
              },
              child: Text(
                "등록",
                style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    fontWeight: FontWeight.w700,
                    color: AppColor.objectColor),
              ),
            )
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: AppColor.objectColor,
              thickness: 3, // 줄의 색상 설정
            ),
          ),
        ),
        body: Obx(() {
          controller.printInfo();
          return SafeArea(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spotImage(),
                      Visibility(
                          key: UniqueKey(),
                          visible: clickImageButton,
                          child: Column(
                            children: [
                              const Divider(
                                  color: AppColor.objectColor, thickness: 1),
                              spotTitle(),
                              Visibility(
                                key: UniqueKey(),
                                visible: clickInfoButton,
                                replacement: Gap(
                                    sizeController.screenHeight.value * 0.4),
                                child: Column(
                                  children: [
                                    const Divider(
                                        color: AppColor.objectColor,
                                        thickness: 1),
                                    spotInfo(),
                                    Visibility(
                                        key: UniqueKey(),
                                        replacement: Gap(
                                            sizeController.screenHeight.value *
                                                0.4),
                                        visible: (controller
                                                    .spotExtraAddress.value !=
                                                '' &&
                                            controller.spotDate.value !=
                                                DateTime(0, 0, 0, 0, 0)),
                                        child: Column(
                                          children: [
                                            const Divider(
                                                color: AppColor.objectColor,
                                                thickness: 1),
                                            spotWeather(),
                                            Visibility(
                                                key: UniqueKey(),
                                                replacement: Column(
                                                  children: [
                                                    clickWeatherButton == false
                                                        ? Text(
                                                            "* 버튼을 눌러 날씨 정보를 받아와주세요.\n* 언제든 수정 가능합니다.",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    sizeController
                                                                        .middleFontSize
                                                                        .value,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: AppColor
                                                                    .objectColor),
                                                          )
                                                        : Text(
                                                            "* 날씨 정보를 자동으로 불러오지 못했습니다.\n* 직접 입력해주세요.",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    sizeController
                                                                        .middleFontSize
                                                                        .value,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                    Gap(sizeController
                                                            .screenHeight
                                                            .value *
                                                        0.4),
                                                  ],
                                                ),
                                                visible: (controller
                                                        .spotWeather.value !=
                                                    0),
                                                child: Column(
                                                  children: [
                                                    const Divider(
                                                        color: AppColor
                                                            .objectColor,
                                                        thickness: 1),
                                                    spotCategory(),
                                                    Gap(sizeController
                                                            .screenHeight
                                                            .value *
                                                        0.4),
                                                  ],
                                                )),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  )));
        }));
  }

  Widget spotImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(sizeController.screenHeight.value * 0.02),
        _buildGroupTitle('사진 업로드'),
        Gap(sizeController.screenHeight.value * 0.03),
        _buildPhotoArea(),
        Gap(sizeController.screenHeight.value * 0.05),
        if (pickedFile == null)
          Text(
            "* 사진은 한장만 업로드됩니다.\n* 사진 업로드 후 추가 정보를 설정할 수 있습니다.",
            style: TextStyle(
                fontSize: sizeController.middleFontSize.value,
                fontWeight: FontWeight.w300,
                color: AppColor.objectColor),
          )
        else
          Visibility(
              visible: !clickImageButton,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    clickImageButton = true;
                  });
                },
                child: Text(
                  "사진 선택",
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w700,
                      color: AppColor.objectColor),
                ),
              ))
      ],
    );
  }

  Widget spotTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(sizeController.screenHeight.value * 0.02),
        _buildGroupTitle('사진 정보'),
        Gap(sizeController.screenHeight.value * 0.02),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SPOT TITLE :  ",
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '사진 명소를 입력해주세요',
                      hintStyle: TextStyle(
                          fontSize: sizeController.middleFontSize.value,
                          fontWeight: FontWeight.w300,
                          color: AppColor.textColor),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.objectColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value,
                        fontWeight: FontWeight.w300,
                        color: AppColor.textColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '사진 명소를 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.spotMainAddress.value = value!;
                    },
                  ),
                ),
              ),
              Text(
                "SPOT Content :",
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '사진 명소에 대해 설명해주세요',
                      hintStyle: TextStyle(
                          fontSize: sizeController.middleFontSize.value,
                          fontWeight: FontWeight.w300,
                          color: AppColor.textColor),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.objectColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    maxLines: 6,
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value,
                        fontWeight: FontWeight.w300,
                        color: AppColor.textColor),
                    onSaved: (value) {
                      controller.spotContent.value = value!;
                    },
                  ),
                ),
              ),
              Gap(sizeController.screenHeight.value * 0.02),
              Center(
                child: Visibility(
                    visible: !clickInfoButton,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          final formKeyState = _formKey1.currentState!;
                          if (formKeyState.validate()) {
                            formKeyState.save();
                            clickInfoButton = true;
                          }
                        });
                      },
                      child: Text(
                        "부가정보 불러오기",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.objectColor),
                      ),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget spotInfo() {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(sizeController.screenHeight.value * 0.02),
          _buildGroupTitle('위치 및 시간 정보'),
          Gap(sizeController.screenHeight.value * 0.02),
          _buildLabeledItem(
            '위치 정보',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotAddress');
            },
          ),
          _buildSpotInfo(Obx(() => controller.spotExtraAddress.value == ''
              ? Text('위치 정보를 불러오지 못했습니다. 추가해주세요.',
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w300,
                      color: Colors.red))
              : Text(
                  controller.spotExtraAddress.value,
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w300,
                      color: AppColor.textColor),
                ))),
          Gap(sizeController.screenHeight.value * 0.05),
          _buildLabeledItem(
            '시간 정보',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotTime');
            },
          ),
          _buildSpotInfo(Obx(() =>
              controller.spotDate.value == DateTime(0, 0, 0)
                  ? Text('시간 정보를 불러오지 못했습니다. 추가해주세요',
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value,
                          fontWeight: FontWeight.w300,
                          color: Colors.red))
                  : Text(
                      DateFormat("yyyy년 MM월 dd일")
                          .add_Hm()
                          .format(controller.spotDate.value),
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value,
                          fontWeight: FontWeight.w300,
                          color: AppColor.textColor),
                    ))),
          Gap(sizeController.screenHeight.value * 0.05),
        ],
      );
    });
  }

  Widget spotWeather() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(sizeController.screenHeight.value * 0.02),
        Row(
          children: [
            _buildGroupTitle('날씨 정보'),
            IconButton(
              onPressed: () async {
                clickWeatherButton = true;
                GetWeather weatherService = GetWeather();
                String condition = await weatherService.getWeatherCondition(
                    controller.spotLatitude.value,
                    controller.spotLongitude.value,
                    controller.spotDate.value);

                setState(() {
                  switch (condition) {
                    case 'Clear':
                      controller.spotWeather.value = 1;
                      break;
                    case 'Clouds':
                      controller.spotWeather.value = 2;
                      break;
                    case 'Rain':
                      controller.spotWeather.value = 3;
                      break;
                    case 'Snow':
                      controller.spotWeather.value = 4;
                      break;
                    default:
                      controller.spotWeather.value = 0;
                  }
                });
              },
              icon: const Icon(
                Icons.refresh_sharp,
                size: 25,
                color: AppColor.objectColor,
              ),
            ),
          ],
        ),
        Gap(sizeController.screenHeight.value * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 1)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 1;
                  });
                },
                icon: const Icon(WeatherIcon.sun),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 2)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 2;
                  });
                },
                icon: const Icon(WeatherIcon.cloud),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 3)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 3;
                  });
                },
                icon: const Icon(WeatherIcon.rain),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 4)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 4;
                  });
                },
                icon: const Icon(WeatherIcon.snow),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
          ],
        ),
        Gap(sizeController.screenHeight.value * 0.02),
        Obx(() => Text(
              (controller.spotWeather.value == 0)
                  ? ""
                  : PostWeather.fromString(
                          weather[controller.spotWeather.value - 1])
                      .title,
              style: TextStyle(
                  fontSize: sizeController.middleFontSize.value,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor),
            )),
        Gap(sizeController.screenHeight.value * 0.03),
      ],
    );
  }

  Widget spotCategory() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(sizeController.screenHeight.value * 0.02),
        _buildGroupTitle('카테고리'),
        Gap(sizeController.screenHeight.value * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: (controller.spotCategory.value == 1)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shadowColor: Colors.black,
                minimumSize: Size(sizeController.screenWidth.value * 0.4,
                    sizeController.screenHeight.value * 0.07),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  controller.spotCategory.value = 1;
                });
              },
              child: Text(
                '나홀로 인생샷',
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w500,
                    color: AppColor.backgroundColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: (controller.spotCategory.value == 2)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shadowColor: Colors.black,
                minimumSize: Size(sizeController.screenWidth.value * 0.4,
                    sizeController.screenHeight.value * 0.07),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  controller.spotCategory.value = 2;
                });
              },
              child: Text(
                '애인과 커플샷',
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w500,
                    color: AppColor.backgroundColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: sizeController.screenHeight * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: (controller.spotCategory.value == 3)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shadowColor: Colors.black,
                minimumSize: Size(sizeController.screenWidth.value * 0.4,
                    sizeController.screenHeight.value * 0.07),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  controller.spotCategory.value = 3;
                });
              },
              child: Text(
                '친구와 우정샷',
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w500,
                    color: AppColor.backgroundColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: (controller.spotCategory.value == 4)
                    ? AppColor.objectColor
                    : AppColor.textColor,
                shadowColor: Colors.black,
                minimumSize: Size(sizeController.screenWidth.value * 0.4,
                    sizeController.screenHeight.value * 0.07),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  controller.spotCategory.value = 4;
                });
              },
              child: Text(
                '가족과 추억샷',
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w500,
                    color: AppColor.backgroundColor),
              ),
            ),
          ],
        ),
        Gap(sizeController.screenHeight.value * 0.05),
      ],
    );
  }

  Widget _buildGroupTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColor.objectColor,
            ),
            Text(
              " $title",
              style: TextStyle(
                  fontSize: sizeController.mainFontSize.value,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledItem(
    String text,
    Widget Function(BuildContext context) builder, {
    void Function()? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.3),
        onTap: onTap,
        child: Ink(
          height: 40,
          padding: EdgeInsets.symmetric(
              horizontal: sizeController.screenHeight.value * 0.03),
          child: Row(
            children: [
              SizedBox(
                width: sizeController.screenWidth.value * 0.7,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor),
                ),
              ),
              Expanded(
                child: builder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotInfo(Widget info) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24), child: info));
  }

  Widget _buildRightArrow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.arrow_forward_ios,
        color: AppColor.objectColor,
        size: sizeController.mainFontSize.value,
      ),
    );
  }

  void _goBackConfirmDialog(BuildContext context) async {
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

  void _postConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppColor.objectColor,
            title: Text(
              '등록',
              style: TextStyle(
                  fontSize: sizeController.mainFontSize.value,
                  fontWeight: FontWeight.w900,
                  color: AppColor.backgroundColor),
            ),
            content: Text(
              '사진 명소를 등록하시겠습니까?',
              style: TextStyle(
                  fontSize: sizeController.middleFontSize.value,
                  fontWeight: FontWeight.w500,
                  color: AppColor.backgroundColor),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  _formKey2.currentState!.save();
                  await _uploadImage();
                  String spotMainAddress = controller.spotMainAddress.value;
                  String spotExtraAddress = controller.spotExtraAddress.value;
                  String spotContent = controller.spotContent.value;
                  double spotLongitude = controller.spotLongitude.value;
                  double spotLatitude = controller.spotLatitude.value;
                  DateTime spotDate = controller.spotDate.value;
                  String spotWeather =
                      weather[controller.spotWeather.value - 1];
                  String spotCategory =
                      category[controller.spotCategory.value - 1];

                  //TODO: userUid 입력, postID???
                  PostModel fireModel = PostModel(
                      postID: 'post1',
                      createdAt: Timestamp.now(),
                      userUid: 'jin',
                      imageURL: imageDownLoadURL,
                      mainAddress: spotMainAddress,
                      extraAddress: spotExtraAddress,
                      content: spotContent,
                      longitude: spotLongitude,
                      latitude: spotLatitude,
                      date: Timestamp.fromDate(spotDate),
                      weather: PostWeather.fromString(spotWeather),
                      category: PostCategory.fromString(spotCategory),
                      likes: LikeModel(userIDs: []));

                  await FireService().createPostInfo(fireModel.toJson());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진 등록 완료'),
                  ));
                  Get.back();
                  Get.back();
                },
                child: Text(
                  '등록',
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
            ]);
      },
    );
  }
}
