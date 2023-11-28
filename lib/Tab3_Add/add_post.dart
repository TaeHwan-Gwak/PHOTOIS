import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photois/Main/data.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';

import 'package:photois/model/post_model.dart';
import '../Tab3_Add/firestore_post.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  int selectedIconNum = 0;

  List<String> weather = ['sun', 'clouds', 'rain', 'snow'];

  List<String> category = ['solo', 'couple', 'friend', 'family'];

  final controller = Get.put((PhotoSpotInfo()));
  final sizeController = Get.put((SizeController()));
  final picker = ImagePicker();
  String imageDownLoadURL = '';

  XFile? pickedFile;
  Exif? exif;
  Map<String, Object>? attributes;
  DateTime? shootingDate;
  ExifLatLong? coordinates;

  @override
  void initState() {
    super.initState();
  }

  Future<void> showError(Object e) async {
    debugPrintStack(
        label: e.toString(), stackTrace: e is Error ? e.stackTrace : null);

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(e.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage() async {
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
        controller.spotDate.value = shootingDate!;
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
        ? SizedBox(
            width: sizeController.screenWidth.value * 0.8,
            height: sizeController.screenWidth.value * 0.8,
            child: Image.file(File(pickedFile!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: sizeController.screenWidth.value * 0.8,
            height: sizeController.screenWidth.value * 0.8,
            color: Colors.grey,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(sizeController.screenHeight.value * 0.09),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              '새 게시물',
              style: TextStyle(fontSize: sizeController.mainFontSize.value),
            ),
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  _goBackConfirmDialog(context);
                },
                icon: Icon(Icons.arrow_back,
                    size: sizeController.bigFontSize.value)),
            actions: [
              TextButton(
                  onPressed: () {
                    _postConfirmDialog(context);
                  },
                  child: Text(
                    "등록",
                    style: TextStyle(
                        fontSize: sizeController.mainFontSize.value,
                        color: Colors.blueGrey),
                  )),
            ],
          ),
        ),
        body: SafeArea(child: buildBody()));
  }

  Widget buildBody() {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverToBoxAdapter(child: spotImage()),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: spotInfo()),
                Gap(sizeController.screenHeight.value * 0.01),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: spotCategory()),
                Gap(sizeController.screenHeight.value * 0.1),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget spotImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: sizeController.screenHeight.value * 0.04),
          child: _buildGroupTitle('사진 업로드'),
        ),
        Gap(sizeController.screenHeight.value * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [InkWell(onTap: getImage, child: _buildPhotoArea())],
        ),
        Gap(sizeController.screenHeight.value * 0.01),
        if (pickedFile == null)
          const Text(" ")
        else
          Text("${coordinates?.longitude}"),
      ],
    );
  }

  Widget spotInfo() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: sizeController.screenHeight.value * 0.02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sizeController.screenHeight.value * 0.04),
            child: _buildGroupTitle('위치 정보'),
          ),
          Gap(sizeController.screenHeight.value * 0.005),
          _buildLabeledItem(
            Obx(() => Text(
                (controller.spotMainAddress.value == '')
                    ? '위치를 입력해주세요'
                    : (controller.spotExtraAddress.value == '')
                        ? '$controller.spotMainAddress.value'
                        : '${controller.spotMainAddress.value}\n(${controller.spotExtraAddress.value})',
                style: TextStyle(fontSize: sizeController.mainFontSize.value))),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotAddress');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
          Gap(sizeController.screenHeight.value * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('시간 정보'),
          ),
          const Gap(4),
          _buildLabeledItem(
            Obx(() => Text(
                (controller.spotDate.value == DateTime(0, 0, 0))
                    ? '시간을 입력해주세요'
                    : DateFormat("yyyy년 MM월 dd일 ")
                        .add_Hm()
                        .format(controller.spotDate.value),
                style: TextStyle(fontSize: sizeController.mainFontSize.value))),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotTime');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
          Gap(sizeController.screenHeight.value * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('날씨 정보'),
          ),
          const Gap(4),
          _buildLabeledItem(
            Obx(() => Text(
                (controller.spotWeather.value == 0)
                    ? '날씨를 확인해주세요'
                    : PostWeather.fromString(
                            weather[controller.spotWeather.value - 1])
                        .title,
                style: TextStyle(fontSize: sizeController.mainFontSize.value))),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotWeather');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget spotCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('카테고리'),
          ),
          const Gap(4),
          _buildLabeledItem(
            Obx(() => Text(
                (controller.spotCategory.value == 0)
                    ? '카테고리를 선택해주세요'
                    : PostCategory.fromString(
                            category[controller.spotCategory.value - 1])
                        .title,
                style: TextStyle(fontSize: sizeController.mainFontSize.value))),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotCategory');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: sizeController.mainFontSize.value,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFADADAD),
        ),
      ),
    );
  }

  Widget _buildLabeledItem(
    Widget text,
    Widget Function(BuildContext context) builder, {
    void Function()? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: InkWell(
        splashColor: Colors.blue.withOpacity(0.3),
        // splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(
              horizontal: sizeController.screenHeight.value * 0.04,
              vertical: sizeController.screenWidth.value * 0.03),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.7, child: text),
              Expanded(
                child: builder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightArrow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.arrow_forward_ios_outlined,
        color: Colors.black,
        size: sizeController.mainFontSize.value,
      ),
    );
  }

  void _goBackConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('돌아가시겠습니까?\n작성 중인 글은 저장되지 않습니다.',
              style: TextStyle(fontSize: sizeController.mainFontSize.value)),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text('확인',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: sizeController.mainFontSize.value)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소',
                  style:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
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
          content: Text('사진을 등록하시겠습니까?',
              style: TextStyle(fontSize: sizeController.mainFontSize.value)),
          actions: [
            TextButton(
              onPressed: () async {
                if (pickedFile != null) {
                  //TODO: 조건 더 붙이기
                  await _uploadImage();
                  DateTime spotDate = controller.spotDate.value;
                  String spotWeather =
                      weather[controller.spotWeather.value - 1];
                  String spotCategory =
                      category[controller.spotCategory.value - 1];

                  PostModel fireModel = PostModel(
                      postID: '',
                      createdAt: DateTime.now(),
                      userUid: '',
                      imageURL: imageDownLoadURL,
                      address: '',
                      longitude: 0.0,
                      latitude: 0.0,
                      date: spotDate,
                      weather: PostWeather.fromString(spotWeather),
                      category: PostCategory.fromString(spotCategory));

                  await FireService().createPostInfo(fireModel.toJson());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진 등록 완료'),
                  ));
                  Get.back();
                  Get.back();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('먼저 사진을 업로드해주세요.'),
                    ),
                  );
                  Get.back();
                }
              },
              child: Text('등록',
                  style:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('돌아가기',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: sizeController.mainFontSize.value)),
            ),
          ],
        );
      },
    );
  }
}
