import 'package:flutter/material.dart';

import '../model/post_model.dart';

class PhotoInfo extends StatefulWidget {
  final PostModel data;

  const PhotoInfo({super.key, required this.data});

  @override
  State<PhotoInfo> createState() => _PhotoInfoState();
}

class _PhotoInfoState extends State<PhotoInfo> {
  late PostModel data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
                  height: 500,
                  width: double.infinity,
                  child: Image.network(
                    data.imageURL ?? 'No imageURL',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ), //받아온 게시물 이미지 넣기
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outlined),
                ),
                const Text("100 Likes"),
              ],
            ),
            Text(data.createdAt.toString()),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FzakEUsma5ZFzdojmEHbo%2Fc6fabe925d0592e219433bb60619b5122c12871aMap.png?alt=media&token=38de594f-df1d-42b7-8eef-c66212f64d07',
                fit: BoxFit.cover,
              ),
            ), //지도 데이터 띄우기
          ],
        ),
      ),
    );
  }
}
