import 'package:cloud_firestore/cloud_firestore.dart';

enum PostWeather {
  sun,
  cloud,
  rain,
  snow,
  ;

  String get title => const <PostWeather, String>{
        PostWeather.sun: '맑음',
        PostWeather.cloud: '구름',
        PostWeather.rain: '비',
        PostWeather.snow: '눈',
      }[this]!;

  static PostWeather fromString(String value) {
    try {
      if (!value.startsWith('PostWeather')) {
        value = 'PostWeather.$value';
      }

      return PostWeather.values.firstWhere((e) => e.toString() == value);
    } catch (e) {
      return PostWeather.sun;
    }
  }
}

enum PostCategory {
  solo,
  couple,
  friend,
  family,
  ;

  String get title => const <PostCategory, String>{
        PostCategory.solo: '나홀로 인생샷',
        PostCategory.couple: '애인과 커플샷',
        PostCategory.friend: '친구와 우정샷',
        PostCategory.family: '가족과 추억샷',
      }[this]!;

  static PostCategory fromString(String value) {
    try {
      if (!value.startsWith('PostCategory.')) {
        value = 'PostCategory.$value';
      }

      return PostCategory.values.firstWhere((e) => e.toString() == value);
    } catch (e) {
      return PostCategory.solo;
    }
  }
}

class LikeModel {
  late List<String> userIDs;

  LikeModel({required this.userIDs});

  // json => Object
  LikeModel.fromJson(dynamic json) {
    userIDs = List<String>.from(json['userIDs']);
  }

  // Object => json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'userIDs': userIDs};
    return data;
  }

  void update() {
    update();
  }
}

class PostModel {
  // 사용되는 자료형
  late bool? postState;
  late Timestamp? createdAt;
  late String? userUid;
  late String? imageURL;
  late String? mainAddress;
  late String? extraAddress;
  late String? content;
  late double? longitude;
  late double? latitude;
  late Timestamp? date;
  late PostWeather? weather;
  late PostCategory? category;
  late List<String> likes;
  late int likesCount;
  String? report;
  late DocumentReference? reference;

  //생성자
  PostModel(
      {required this.postState,
      required this.createdAt,
      required this.userUid,
      required this.imageURL,
      required this.mainAddress,
      required this.extraAddress,
      required this.content,
      required this.longitude,
      required this.latitude,
      required this.date,
      required this.weather,
      required this.category,
      required this.likes,
      required this.likesCount,
      this.report,
      this.reference});

  //json => Object로, firestore에서 불러올때
  PostModel.fromJson(dynamic json, this.reference) {
    postState = json['postState'];
    createdAt = json['createdAt'];
    userUid = json['userUid'];
    imageURL = json['imageURL'];
    mainAddress = json['mainAddress'];
    extraAddress = json['extraAddress'];
    content = json['content'];
    longitude = double.parse(json['longitude'].toString());
    latitude = double.parse(json['latitude'].toString());
    date = json['date'];
    likes = List<String>.from(json['likes']);
    likesCount = json['likesCount'];
    weather = PostWeather.fromString(json['weather'] as String);
    category = PostCategory.fromString(json['category'] as String);
    report = json['report'];
  }

  // Named Constructor with Initializer
  // fromSnapShot Named Constructor로 snapshot 자료가 들어오면 이걸 다시 Initializer를 통해
  // fromJson Named Constructor를 실행함
  // DocumentSnapshot 자료형을 받아 올때 사용하는 Named Constructor
  // 특정한 자료를 받아 올때 사용한다.
  PostModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  // Named Constructor with Initializer
  // 컬렉션 내에 특정 조건을 만족하는 데이터를 다 가지고 올때 사용한다.
  PostModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  //Object => json, firestore에 저장할때
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postState'] = postState;
    map['createdAt'] = createdAt;
    map['userUid'] = userUid;
    map['imageURL'] = imageURL;
    map['mainAddress'] = mainAddress;
    map['extraAddress'] = extraAddress;
    map['content'] = content;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['date'] = date;
    map['weather'] = weather?.name;
    map['category'] = category?.name;
    map['likes'] = likes;
    map['likesCount'] = likes.length;
    map['report'] = report;
    return map;
  }

  static int compareByLikes(PostModel a, PostModel b) {
    // 'likesCount' 필드를 기준으로 정렬
    return b.likesCount.compareTo(a.likesCount);
  }
}
