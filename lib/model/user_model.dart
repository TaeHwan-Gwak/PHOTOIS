import 'package:photois/service/firebase.auth.dart';
import 'package:photois/service/firebase.boot.dart';
import 'package:photois/typedef.dart';

enum UserType {
  photographer,
  normal,
  ;

  String get title => const <UserType, String>{
        UserType.photographer: '포토그래퍼',
        UserType.normal: '일반 사용자',
      }[this]!;

  static UserType fromString(String value) {
    try {
      if (!value.startsWith('UserType.')) {
        value = 'UserType.$value';
      }

      return UserType.values.firstWhere((e) => e.toString() == value);
    } catch (e) {
      return UserType.normal;
    }
  }
}

enum PrefferedCategory {
  solo,
  couple,
  friend,
  family,
  ;

  String get title => const <PrefferedCategory, String>{
        PrefferedCategory.solo: '나홀로 인생샷',
        PrefferedCategory.couple: '커플 사랑샷',
        PrefferedCategory.friend: '친구 우정샷',
        PrefferedCategory.family: '가족 추억샷',
      }[this]!;

  static PrefferedCategory fromString(String value) {
    try {
      if (!value.startsWith('PrefferedCategory.')) {
        value = 'PrefferedCategory.$value';
      }

      return PrefferedCategory.values.firstWhere((e) => e.toString() == value);
    } catch (e) {
      return PrefferedCategory.solo;
    }
  }
}

class UserModel {
  late String uid;
  late String nickname;
  late String email;
  late String? instagramId;
  late UserType type;
  late PrefferedCategory category;
  late DateTime createdAt;

  UserModel({
    required this.uid,
    required this.nickname,
    required this.email,
    this.instagramId,
    required this.type,
    required this.category,
    required this.createdAt,
  });

  factory UserModel.temp({
    String nickname = '전혜지',
    String email = 'heji0826@gmail.com',
  }) {
    return UserModel(
      uid: FbAuth.isLogged ? FbAuth.uid! : 'test-uid',
      nickname: nickname,
      email: email,
      instagramId: null,
      type: UserType.normal,
      category: PrefferedCategory.solo,
      createdAt: DateTime.now().toUtc(),
    );
  }

  factory UserModel.fromJson(JsonMap json) {
    return UserModel(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      instagramId: json['instagramId'] as String?,
      type: UserType.fromString(json['type'] as String),
      category: PrefferedCategory.fromString(json['category'] as String),
      createdAt: DateTime.parse(json['cretedAt'] as String).toUtc(),
    );
  }

  static UserModel? fromJsonOrNull(JsonMap? json) {
    if (json == null) return null;

    try {
      return UserModel.fromJson(json);
    } catch (e) {}

    return null;
  }

  JsonMap toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'email': email,
      'instagramId': instagramId,
      'type': type.name,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  bool operator ==(other) => other is UserModel && other.uid == uid;

  //----------------------------------------------------------------------------
  // db
  //----------------------------------------------------------------------------
  static const String collectionName = 'users';

  static JsonMapColRef getColRef() => fs.collection(collectionName);
  static JsonMapDocRef getDocRef(String uid) => getColRef().doc(uid);

  //----------------------------------------------------------------------------
  // crud
  //----------------------------------------------------------------------------
  static Future<UserModel?> fetch(String uid) async {
    final doc = await getDocRef(uid).get();
    return UserModel.fromJsonOrNull(doc.data());
  }

  Future<void> save() async {
    await getDocRef(uid).set(toJson());
  }
}
