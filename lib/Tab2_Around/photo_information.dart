import 'package:flutter/material.dart';

class PhotoInfo extends StatefulWidget {
  const PhotoInfo({super.key});

  @override
  State<PhotoInfo> createState() => _PhotoInfoState();
}

class _PhotoInfoState extends State<PhotoInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물'),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FzakEUsma5ZFzdojmEHbo%2Fe10d563c5c1442309bff8647f1c82eeb6612ba71032_AshleyMatt%201.png?alt=media&token=0d8a1d8a-37d3-4d33-aa66-5901e6b5231c',
                    fit: BoxFit.cover,
                  )),
            ]), //받아온 게시물 이미지 넣기
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outlined)),
                const Text("100 Likes"),
              ],
            ),
            const Text("2023년11월23일"),
            SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FzakEUsma5ZFzdojmEHbo%2Fc6fabe925d0592e219433bb60619b5122c12871aMap.png?alt=media&token=38de594f-df1d-42b7-8eef-c66212f64d07',
                  fit: BoxFit.cover,
                )), //지도 데이터 띄우기
          ],
        ),
      ),
    );
  }
}
