import 'package:flutter/material.dart';
import 'package:photois/post/post_card.dart';
import '../Main/data.dart';
import 'package:get/get.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';
import '../style/style.dart';

enum ViewSelect {
  likeDown,
  likeUp,
  createDateDown,
  createDateUp;

  String get title => const <ViewSelect, String>{
        ViewSelect.likeDown: '좋아요 많은 순',
        ViewSelect.likeUp: '좋아요 적은 순',
        ViewSelect.createDateDown: '최신순',
        ViewSelect.createDateUp: '오래된 순',
      }[this]!;

  int get num => const <ViewSelect, int>{
        ViewSelect.likeDown: 1,
        ViewSelect.likeUp: 2,
        ViewSelect.createDateDown: 3,
        ViewSelect.createDateUp: 4,
      }[this]!;
}

class ReportPost extends StatefulWidget {
  final String userUID;

  const ReportPost({super.key, required this.userUID});

  @override
  State<ReportPost> createState() => _ReportPostState();
}

class _ReportPostState extends State<ReportPost> {
  late String userUID;
  final sizeController = Get.put((SizeController()));
  int select = 0;

  @override
  void initState() {
    super.initState();
    userUID = widget.userUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        title: Center(
          child: Text(
            "Report POSTs",
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
        actions: [SizedBox(width: sizeController.screenWidth.value * 0.13)],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectButton('게시물이 적합하지 않음', select == 1, () {
            setState(() {
              if (select == 1) {
                select = 0;
              } else {
                select = 1;
              }
            });
          }),
          Visibility(
              visible: select == 1, child: getReportPosts('게시물이 적합하지 않음')),
          selectButton('인스타그램 정보 도용', select == 2, () {
            setState(() {
              if (select == 2) {
                select = 0;
              } else {
                select = 2;
              }
            });
          }),
          Visibility(
              visible: select == 2, child: getReportPosts('인스타그램 정보 도용')),
          selectButton('유해한 사진 및 게시글', select == 3, () {
            setState(() {
              if (select == 3) {
                select = 0;
              } else {
                select = 3;
              }
            });
          }),
          Visibility(
              visible: select == 3, child: getReportPosts('유해한 사진 및 게시글')),
          selectButton('기타', select == 4, () {
            setState(() {
              if (select == 4) {
                select = 0;
              } else {
                select = 4;
              }
            });
          }),
          Visibility(visible: select == 4, child: getReportPosts('기타')),
          const Divider(color: AppColor.objectColor, thickness: 3),
          SizedBox(
            height: sizeController.screenHeight.value * 0.02,
          ),
        ],
      ),
    );
  }

  Widget getReportPosts(String report) {
    return Expanded(
      child: FutureBuilder<List<PostModel>>(
        future: FireService().getFireModelReport(report: report),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<PostModel> datas = snapshot.data!;
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: sizeController.screenHeight.value * 0.01,
                    mainAxisSpacing: sizeController.screenHeight.value * 0.01,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: datas.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostModel data = datas[index];

                    return PostCard(
                      data: data,
                      size: sizeController.screenHeight.value * 0.3,
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return const Text("No data");
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget selectButton(
    String title,
    bool state,
    void Function()? onTap,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.textColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w700,
                color: AppColor.objectColor),
          ),
          !state
              ? const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.objectColor,
                )
              : const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.objectColor,
                  size: 40,
                ),
        ],
      ),
    );
  }
}
