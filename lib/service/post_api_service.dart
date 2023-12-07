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

  ///Tab1-1: 주변 인기장소 추천
  Future<List<PostModel>> getFireModelMain1(
      {required double lat, required double lng}) async {
    double epsilon = 0.01; //1km

    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");

    Query<Map<String, dynamic>> latitudeQuery = collectionReference
        .where("postState", isEqualTo: true)
        .where("latitude",
            isGreaterThanOrEqualTo: lat - epsilon,
            isLessThanOrEqualTo: lat + epsilon);

    Query<Map<String, dynamic>> longitudeQuery = collectionReference
        .where("postState", isEqualTo: true)
        .where("longitude",
            isGreaterThanOrEqualTo: lng - epsilon,
            isLessThanOrEqualTo: lng + epsilon);

    List<QuerySnapshot<Map<String, dynamic>>> querySnapshots =
        await Future.wait([latitudeQuery.get(), longitudeQuery.get()]);

    List<List<PostModel>> resultList = [];

    for (QuerySnapshot<Map<String, dynamic>> querySnapshot in querySnapshots) {
      List<PostModel> posts = [];
      for (var doc in querySnapshot.docs) {
        PostModel postModel = PostModel.fromQuerySnapshot(doc);
        posts.add(postModel);
      }
      resultList.add(posts);
    }

    List<PostModel> intersectedPosts = resultList[0]
        .where((post) => resultList[1]
            .any((otherPost) => post.reference != otherPost.reference))
        .toList();

    intersectedPosts.sort((a, b) => PostModel.compareByLikes(a, b));

    List<PostModel> limitedPosts = intersectedPosts.take(5).toList();
    return limitedPosts;
  }

  ///Tab1-2: 선호 카테고리 기반 추천
  Future<List<PostModel>> getFireModelMain2(
      {required PostCategory category}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: true)
            .where("category", isEqualTo: category.name) //category.name
            .orderBy("likesCount", descending: true)
            .limit(5)
            .get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab1-3: 전체 랭킹
  Future<List<PostModel>> getFireModelMain3() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: true)
            .orderBy("likesCount", descending: true)
            .limit(5)
            .get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab2: 전체 포스트 불러오기
  Future<List<PostModel>> getFireModelAll() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: true)
            .orderBy("likesCount", descending: true)
            .limit(5)
            .get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab2: 날씨 필터링
  Future<List<PostModel>> getFireModelWeather(
      {required PostWeather weather}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: true)
            .where("weather", isEqualTo: weather.name)
            .get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab4: 사용자uid 기반 포스트 불러오기
  ///1번 좋아요순 내림차순
  ///2번 좋아요순 오름차순
  ///3번 등록순 내림차순
  ///4번 등록순 오름차순
  Future<List<PostModel>> getFireModelUser(
      {required String userUid, required int selectNum}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    Query<Map<String, dynamic>> query = collectionReference
        .where("postState", isEqualTo: true)
        .where("userUid", isEqualTo: userUid);

    if (selectNum == 1) {
      query = query.orderBy("likesCount", descending: true);
    } else if (selectNum == 2) {
      query = query.orderBy("likesCount");
    } else if (selectNum == 3) {
      query = query.orderBy("createdAt", descending: true);
    } else if (selectNum == 4) {
      query = query.orderBy("createdAt");
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab4: 사용자가 반응한 포스트 불러오기
  ///1번 좋아요순 내림차순
  ///2번 좋아요순 오름차순
  ///3번 등록순 내림차순
  ///4번 등록순 오름차순
  Future<List<PostModel>> getFireModelUserLike(
      {required String userUid, required int selectNum}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    Query<Map<String, dynamic>> query = collectionReference
        .where("postState", isEqualTo: true)
        .where("likes", arrayContains: userUid);

    if (selectNum == 1) {
      query = query.orderBy("likesCount", descending: true);
    } else if (selectNum == 2) {
      query = query.orderBy("likesCount");
    } else if (selectNum == 3) {
      query = query.orderBy("createdAt", descending: true);
    } else if (selectNum == 4) {
      query = query.orderBy("createdAt");
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab4: 신고 받은 포스트 불러오기 - 체크 X
  Future<List<PostModel>> getFireModelReport({required String report}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: false)
            .where("report", isEqualTo: report)
            .get();

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
