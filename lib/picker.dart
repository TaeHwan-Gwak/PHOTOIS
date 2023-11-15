import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:native_exif/native_exif.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  Exif? exif;
  Map<String, Object>? attributes;
  DateTime? shootingDate;
  ExifLatLong? coordinates;

  @override
  void initState() {
    super.initState();
  }

  Future<void> showError(Object e) async {
    debugPrintStack(label: e.toString(), stackTrace: e is Error ? e.stackTrace : null);

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

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      File _file = File(pickedFile.path);

      // Firebase Storage에 이미지 업로드
      await FirebaseStorage.instance.ref("test/test_image").putFile(_file);

      // Exif 데이터 가져오기
      exif = await Exif.fromPath(pickedFile.path);
      attributes = await exif!.getAttributes();
      shootingDate = await exif!.getOriginalDate();
      coordinates = await exif!.getLatLong();

      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  Future closeImage() async {
    await exif?.close();
    shootingDate = null;
    attributes = {};
    exif = null;
    coordinates = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PHOTOIS'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image != null
                  ? Container(
                width: 300,
                height: 300,
                child: Image.file(File(_image!.path)),
              )
                  : Container(
                width: 300,
                height: 300,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                child: const Text('갤러리에서 이미지 가져오기'),
              ),
              if (_image != null)
                Column(
                  children: [
                    Text("The selected image has ${attributes?.length ?? 0} attributes."),
                    Text("It was taken at ${shootingDate.toString()}"),
                    Text(attributes?["UserComment"]?.toString() ?? ''),
                    Text("Attributes: $attributes"),
                    Text("Coordinates: $coordinates"),
                    ElevatedButton(
                      onPressed: closeImage,
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      child: const Text('이미지 닫기'),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
