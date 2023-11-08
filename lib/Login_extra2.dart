import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login_extra3.dart';

class loginExtra2 extends StatefulWidget {
  const loginExtra2({super.key});

  @override
  State<loginExtra2> createState() => _loginExtra2State();
}

class _loginExtra2State extends State<loginExtra2> {
  final _formKey = GlobalKey<FormState>();
  String nickName = '';
  var _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                    backgroundColor: _color,
                    shadowColor: Colors.black,
                    minimumSize: Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _color = Colors.blueGrey;
                    });
                  },
                  child: Text('포토그래퍼'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: _color,
                    shadowColor: Colors.black,
                    minimumSize: Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _color = Colors.blueGrey;
                    });
                  },
                  child: Text('일반 사용자'),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              " 인스타그램 아이디",
              style: TextStyle(fontSize: 15),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text.';
                  }
                  return null;
                },
                onSaved: (value) {
                  nickName = value!;
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const loginExtra3()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
