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

class MyLikePost extends StatefulWidget {
  final String userUID;

  const MyLikePost({super.key, required this.userUID});

  @override
  State<MyLikePost> createState() => _MyLikePostState();
}

class _MyLikePostState extends State<MyLikePost> {
  late String userUID;
  final sizeController = Get.put((SizeController()));
  int selectNum = 0;
  ViewSelect _viewSelect = ViewSelect.likeDown;

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
            "My Like POSTs",
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
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: sizeController.screenWidth.value * 0.35,
              child: DropdownButton<ViewSelect>(
                  underline: Container(height: 0),
                  iconEnabledColor: AppColor.objectColor,
                  dropdownColor: AppColor.backgroundColor,
                  value: _viewSelect,
                  isExpanded: true,
                  onChanged: (ViewSelect? newValue) {
                    setState(() {
                      _viewSelect = newValue!;
                      selectNum = newValue.num;
                    });
                  },
                  items: ViewSelect.values.map((ViewSelect status) {
                    return DropdownMenuItem<ViewSelect>(
                      value: status,
                      child: Text(status.title,
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w600,
                              color: AppColor.objectColor)),
                    );
                  }).toList()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: FireService()
                  .getFireModelUserLike(userUid: userUID, selectNum: selectNum),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<PostModel> datas = snapshot.data!;
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing:
                            sizeController.screenHeight.value * 0.01,
                        mainAxisSpacing:
                            sizeController.screenHeight.value * 0.01,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: datas.length,
                      itemBuilder: (BuildContext context, int index) {
                        PostModel data = datas[index];
                        return PostCard(
                          data: data,
                          size: sizeController.screenHeight.value * 0.3,
                        );
                      },
                    );
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
          ),
          const Divider(color: AppColor.objectColor, thickness: 3),
          SizedBox(
            height: sizeController.screenHeight.value * 0.02,
          ),
        ],
      ),
    );
  }
}
