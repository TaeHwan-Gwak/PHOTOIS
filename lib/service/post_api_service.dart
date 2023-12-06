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
      {required double lat, required double lon}) async {
    double epsilon = 0.002; //TODO: 값 지정

    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");

    // latitude 조건을 포함한 쿼리
    Query<Map<String, dynamic>> latitudeQuery = collectionReference
        .where("postState", isEqualTo: true)
        .where("latitude",
            isGreaterThanOrEqualTo: lat - epsilon,
            isLessThanOrEqualTo: lat + epsilon);

    // longitude 조건을 포함한 쿼리
    Query<Map<String, dynamic>> longitudeQuery = collectionReference
        .where("postState", isEqualTo: true)
        .where("longitude",
            isGreaterThanOrEqualTo: lon - epsilon,
            isLessThanOrEqualTo: lon + epsilon);

    // Future.wait를 사용하여 두 쿼리를 동시에 실행하고 결과를 기다림
    List<QuerySnapshot<Map<String, dynamic>>> querySnapshots =
        await Future.wait([latitudeQuery.get(), longitudeQuery.get()]);

    // 각 쿼리의 결과를 저장할 리스트
    List<List<PostModel>> resultList = [];

    // 각 쿼리의 결과를 PostModel로 변환하여 리스트에 저장
    for (QuerySnapshot<Map<String, dynamic>> querySnapshot in querySnapshots) {
      List<PostModel> posts = [];
      for (var doc in querySnapshot.docs) {
        PostModel postModel = PostModel.fromQuerySnapshot(doc);
        posts.add(postModel);
      }
      resultList.add(posts);
    }

    // 두 리스트의 교집합을 찾기
    List<PostModel> intersectedPosts = resultList[0]
        .where((post) => resultList[1]
            .any((otherPost) => post.reference != otherPost.reference))
        .toList();

    // likesCount를 기준으로 정렬
    intersectedPosts.sort((a, b) => PostModel.compareByLikes(a, b));

    // 상위 5개만 선택
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

  ///Tab4: 사용자uid 기반 포스트 불러오기 - 체크 X
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

  ///Tab4: 사용자가 반응한 포스트 불러오기 - 체크 X
  ///좋아요순 내림차순(만약 좋아요한 순으로 하려면 모델 변경 필요)
  Future<List<PostModel>> getFireModelUserLike(
      {required String userUid}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where("postState", isEqualTo: true)
            .where("like", arrayContains: [userUid])
            .orderBy("likesCount", descending: true)
            .get();

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      posts.add(postModel);
    }
    return posts;
  }

  ///Tab4: 신고 받은 포스트 불러오기 - 체크 X
  Future<List<PostModel>> getFireModelReport() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("PostInfo");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.where("postState", isEqualTo: false).get();

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
