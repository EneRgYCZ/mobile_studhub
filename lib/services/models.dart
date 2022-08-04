import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Post {
  int likes;
  String uid;
  String date;
  List skills;
  String text;
  String userName;
  String userPhoto;

  Post({
    this.uid = '',
    this.likes = 0,
    this.date = '',
    this.text = '',
    this.userName = '',
    this.userPhoto = '',
    this.skills = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class UserInfo {
  String uid;
  String bio;
  bool isVerified;
  String userName;
  String userPhoto;
  List<String> userContacts = <String>[];

  UserInfo({
    this.uid = '',
    this.bio = '',
    this.userName = '',
    this.userPhoto = '',
    this.isVerified = false,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class Blog {
  String title;
  List text;
  String photo;

  Blog({this.title = '', this.photo = '', this.text = const []});
  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
  Map<String, dynamic> toJson() => _$BlogToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class Message {
  String uid;
  String text;
  @TimestampConverter()
  final DateTime sentAt;

  Message({this.uid = '', this.text = '', required this.sentAt});
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
