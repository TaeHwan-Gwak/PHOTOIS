import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:native_exif/native_exif.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

    setState(() {});
  }

  Future closeImage() async {
    await exif?.close();
    shootingDate = null;
    attributes = {};
    exif = null;
    coordinates = null;

    setState(() {});
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
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPhotoArea(),
            if (pickedFile == null)
              const Text(" ")
            else
              Column(
                children: [
                  Text(shootingDate.toString()),
                  Text(attributes?["UserComment"]?.toString() ?? ''),
                  Text("Attributes: $attributes"),
                  Text("Coordinates: $coordinates"),
                  TextButton(
                    onPressed: () async {
                      try {
                        await exif!.writeAttributes({
                          'GPSLatitude': '1.0',
                          'GPSLatitudeRef': 'N',
                          'GPSLongitude': '2.0',
                          'GPSLongitudeRef': 'W',
                        });

                        coordinates = await exif!.getLatLong();

                        setState(() {});
                      } catch (e) {
                        showError(e);
                      }
                    },
                    child: const Text('Update GPS attributes'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('갤러리'),
            ),
          ],
        ),
      ),
    );
  }
}
