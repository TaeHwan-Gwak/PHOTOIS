import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photois/model/post_model.dart';

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
  Future createNewPost(Map<String, dynamic> json) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("post_db").doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }*/

  // READ 각각의 데이터를 콕 집어서 가져올때
  Future<PostModel> getFireModel(String userkey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("PostInfo").doc(userkey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    PostModel fireModel = PostModel.fromSnapShot(documentSnapshot);
    return fireModel;
  }

  //READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<PostModel>> getFireModels() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        //await collectionReference.orderBy("like", descending: true).get();
        await collectionReference.get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

//Delete
  Future<void> delPost(DocumentReference reference) async {
    await reference.delete();
  }

//Update
  Future<void> updatePost(
      {required Map<String, dynamic> json,
      required DocumentReference reference}) async {
    await reference.set(json, SetOptions(merge: true));
  }
}
