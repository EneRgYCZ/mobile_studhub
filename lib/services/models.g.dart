// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      uid: json['uid'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      title: json['title'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      userPhoto: json['userPhoto'] as String? ?? '',
      skills: json['skills'] as List<dynamic>? ?? const [],
      interests: json['interests'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'likes': instance.likes,
      'uid': instance.uid,
      'skills': instance.skills,
      'text': instance.text,
      'title': instance.title,
      'postId': instance.postId,
      'interests': instance.interests,
      'userName': instance.userName,
      'userPhoto': instance.userPhoto,
      'date': const TimestampConverter().toJson(instance.date),
    };

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      uid: json['uid'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userPhoto: json['userPhoto'] as String? ?? '',
      notifications: json['notifications'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
    )
      ..skills =
          (json['skills'] as List<dynamic>).map((e) => e as String).toList()
      ..history =
          (json['history'] as List<dynamic>).map((e) => e as String).toList()
      ..contacts =
          (json['contacts'] as List<dynamic>).map((e) => e as String).toList()
      ..interests =
          (json['interests'] as List<dynamic>).map((e) => e as String).toList()
      ..likedPosts = (json['likedPosts'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'bio': instance.bio,
      'isVerified': instance.isVerified,
      'userName': instance.userName,
      'userPhoto': instance.userPhoto,
      'notifications': instance.notifications,
      'skills': instance.skills,
      'history': instance.history,
      'contacts': instance.contacts,
      'interests': instance.interests,
      'likedPosts': instance.likedPosts,
    };

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      title: json['title'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      text: json['text'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'photo': instance.photo,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      uid: json['uid'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sentAt: const TimestampConverter().fromJson(json['sentAt'] as Timestamp),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'uid': instance.uid,
      'text': instance.text,
      'sentAt': const TimestampConverter().toJson(instance.sentAt),
    };

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      participants: json['participants'] as List<dynamic>? ?? const [],
      roomId: json['roomId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sentAt: const TimestampConverter().fromJson(json['sentAt'] as Timestamp),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'participants': instance.participants,
      'text': instance.text,
      'sentAt': const TimestampConverter().toJson(instance.sentAt),
    };

PostComment _$PostCommentFromJson(Map<String, dynamic> json) => PostComment(
      uid: json['uid'] as String? ?? '',
      text: json['text'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userPhoto: json['userPhoto'] as String? ?? '',
      postedAt:
          const TimestampConverter().fromJson(json['postedAt'] as Timestamp),
    );

Map<String, dynamic> _$PostCommentToJson(PostComment instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'text': instance.text,
      'userName': instance.userName,
      'userPhoto': instance.userPhoto,
      'postedAt': const TimestampConverter().toJson(instance.postedAt),
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      title: json['title'] as String? ?? '',
      numberOfPosts: json['numberOfPosts'] as int? ?? 0,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'title': instance.title,
      'numberOfPosts': instance.numberOfPosts,
    };
