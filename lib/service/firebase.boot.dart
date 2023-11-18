import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photois/firebase_options.dart';
import 'package:photois/service/firebase.auth.dart';

late FirebaseFirestore fs;
late FirebaseStorage bucket;
late Reference userBucketRef;

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  fs = FirebaseFirestore.instance;
  bucket = FirebaseStorage.instance;

  userBucketRef = bucket.ref('users');

  await FbAuth.init();
}
