import 'package:flutter/material.dart';

class LoginExtra2 extends StatefulWidget {
  const LoginExtra2({super.key});

  @override
  State<LoginExtra2> createState() => _LoginExtra2State();
}

class _LoginExtra2State extends State<LoginExtra2> {
  final _formKey = GlobalKey<FormState>();
  int checkPhotographer = -1;
  String instagramID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "추가정보를 입력해주세요",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              " 포토그래퍼 여부",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (checkPhotographer == 1)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      checkPhotographer = 1;
                    });
                  },
                  child: const Text('포토그래퍼'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (checkPhotographer == 2)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      checkPhotographer = 2;
                    });
                  },
                  child: const Text('일반 사용자'),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              " 인스타그램 아이디(선택)",
              style: TextStyle(fontSize: 15),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                    counterText: '정확하게 기입해주세요',
                    counterStyle: TextStyle(),
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside)),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text.';
                  }
                  return null;
                },
                onSaved: (value) {
                  instagramID = value!;
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (checkPhotographer != -1) {
            Navigator.pushNamed(context, '/login+3');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('포토그래퍼 여부를 선택해주세요'),
            ));
          }
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
