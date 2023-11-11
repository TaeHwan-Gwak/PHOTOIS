import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginExtra1 extends StatefulWidget {
  const LoginExtra1({super.key});

  @override
  State<LoginExtra1> createState() => _LoginExtra1State();
}

class _LoginExtra1State extends State<LoginExtra1> {
  final _formKey = GlobalKey<FormState>();
  String nickName = ''; //###

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
                decoration: const InputDecoration(
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside)),
                    errorStyle: TextStyle(),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ))),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|0-9]'),
                    allow: true,
                  )
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임 입력은 필수입니다.';
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
          final formKeyState = _formKey.currentState!;
          if (formKeyState.validate()) {
            formKeyState.save();
            Navigator.pushNamed(context, '/login+2');
          }
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
