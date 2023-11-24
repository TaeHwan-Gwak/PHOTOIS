import 'package:cloud_firestore/cloud_firestore.dart';

class FireService {
  // 싱글톤 패턴
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();

  //Create
  Future createPostInfo(Map<String, dynamic> json) async {
    // 초기화
    await FirebaseFirestore.instance.collection("PostInfo").add(json);
  }
  /*
  // Create
  Future createNewMotto(Map<String, dynamic> json) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("motto_db").doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  // READ 각각의 데이터를 콕 집어서 가져올때
  Future<PostModel> getFireModel(String userkey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("motto_db").doc(userkey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    PostModel fireModel = PostModel.fromSnapShot(documentSnapshot);
    return fireModel;
  }

  //READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<PostModel>> getFireModels() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("motto_db");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy("date").get();

    List<PostModel> mottos = [];
    for (var doc in querySnapshot.docs) {
      PostModel fireModel = PostModel.fromQuerySnapshot(doc);
      mottos.add(fireModel);
    }
    return mottos;
  }

//Delete
  Future<void> delFireModel(DocumentReference reference) async {
    await reference.delete();
  }

//Update
  Future<void> updateFireModel(
      Map<String, dynamic> json, DocumentReference reference) async {
    await reference.set(json);
  }*/
}
