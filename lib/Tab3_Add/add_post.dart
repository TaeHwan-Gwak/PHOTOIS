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

import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<String> weather = ["맑음", "흐림", "구름", "비", "눈"];

  List<String> category = [
    "나홀로 인생샷",
    "애인과 커플샷",
    "친구와 우정샷",
    "가족과 추억샷",
  ];
  final controller = Get.put((PhotoSpotInfo()));
  final picker = ImagePicker();

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
      await storageReference.putFile(File(pickedFile!.path));
      print('Image uploaded to Firebase Storage');
    } else {
      print('No image selected.');
    }
  }

  Widget _buildPhotoArea() {
    return pickedFile != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(pickedFile!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('새 게시물'),
          actions: [
            TextButton(
                onPressed: () async {
                  _uploadImage();
                  PostModel fireModel =
                      PostModel(motto: 'hi', date: Timestamp.now());

                  await FireService().createPostInfo(fireModel.toJson());
                },
                child: const Text(
                  "등록",
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                )),
          ],
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
                const Gap(8),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: spotCategory()),
                const Gap(180),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget spotImage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('사진 업로드'),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [InkWell(onTap: getImage, child: _buildPhotoArea())],
          ),
          const Gap(12),
          if (pickedFile == null)
            const Text(" ")
          else
            Text("${new DateFormat().format(shootingDate!)}"),
        ],
      ),
    );
  }

  Widget spotInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('위치 정보'),
          ),
          const Gap(4),
          _buildLabeledItem(
            const Text('위치를 입력해주세요',
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 15)),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotAddress');
            },
          ),
          const Gap(20),
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
                )),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotTime');
            },
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('날씨 정보'),
          ),
          const Gap(4),
          _buildLabeledItem(
            Obx(() => Text((controller.spotWeather.value == 0)
                ? '날씨를 확인해주세요'
                : weather[controller.spotWeather.value - 1])),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotWeather');
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
            Obx(() => Text((controller.spotCategory.value == 0)
                ? '카테고리를 선택해주세요'
                : category[controller.spotCategory.value - 1])),
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              Get.toNamed('/spotCategory');
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
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFFADADAD),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
    return const Align(
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
      ),
    );
  }
}
