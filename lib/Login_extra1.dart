import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login_extra2.dart';

class loginExtra1 extends StatefulWidget {
  const loginExtra1({super.key});

  @override
  State<loginExtra1> createState() => _loginExtra1State();
}

class _loginExtra1State extends State<loginExtra1> {
  final _formKey = GlobalKey<FormState>();
  String nickName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false),
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
              " 닉네임",
              style: TextStyle(fontSize: 15),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 11,
                decoration: const InputDecoration(),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|0-9]'),
                    allow: true,
                  )
                ],
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
              MaterialPageRoute(builder: (context) => const loginExtra2()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
