import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  // 사용되는 자료형
  String? motto;
  Timestamp? date;
  DocumentReference? reference;

  //생성자
  PostModel({
    this.motto,
    this.date,
    this.reference,
  });

  //json => Object로, firestore에서 불러올때
  PostModel.fromJson(dynamic json, this.reference) {
    motto = json['motto'];
    date = json['date'];
  }

  PostModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  PostModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  //Object => json, firestore에 저장할때
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['motto'] = motto;
    map['date'] = date;
    return map;
  }
}
