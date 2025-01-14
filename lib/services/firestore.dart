import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:studhub/services/auth.dart';
import 'package:studhub/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

// **************************************************************************
// POSTS RELATED FUNCTIONS
// **************************************************************************

  Stream<List<Post>> streamPosts(List interests) {
    return _db
        .collection('posts')
        .where("interests", arrayContainsAny: interests)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => Post.fromJson(document.data()))
            .toList());
  }

  Future<void> createPost(String text, String title, List skills,
      UserDetails user, List listOfTags) async {
    var ref = _db.collection('posts');
    for (var y in Iterable.generate(listOfTags.length)) {
      _db
          .collection("interestTags")
          .where("title", isEqualTo: listOfTags[y])
          .get()
          .then((value) async {
        for (var i in Iterable.generate(value.size)) {
          await _db
              .collection("interestTags")
              .doc(value.docs[i].id)
              .update({"numberOfPosts": FieldValue.increment(1)});
        }
      });
    }

    var newData = {
      'likes': 0,
      'text': text,
      "postId": "",
      'title': title,
      'uid': user.uid,
      'skills': skills,
      'interests': listOfTags,
      'date': Timestamp.now(),
      'userName': user.userName,
      'userPhoto': user.userPhoto,
    };

    var result = await ref.add(newData);

    await _db.collection("posts").doc(result.id).update({"postId": result.id});
  }

  Future<List<Post>> findRelatedPosts(skill) async {
    var ref = _db.collection('posts');
    var snapshot = await ref.where("skills", arrayContains: skill).get();
    var data = snapshot.docs.map((s) => s.data());
    var posts = data.map((d) => Post.fromJson(d));
    return posts.toList();
  }

  void deletePost(Post post) async {
    List docId = [];
    await _db
        .collection('posts')
        .where("postId", isEqualTo: post.postId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        docId.add(doc.id);
      }
    });

    for (var y in Iterable.generate(post.interests.length)) {
      _db
          .collection("interestTags")
          .where("title", isEqualTo: post.interests[y])
          .get()
          .then((value) async {
        for (var i in Iterable.generate(value.size)) {
          await _db
              .collection("interestTags")
              .doc(value.docs[i].id)
              .update({"numberOfPosts": FieldValue.increment(-1)});
        }
      });
    }

    var delete = _db.collection('posts').doc(docId[0]);

    try {
      await delete.delete();
    } catch (e) {
      // return e;
    }
  }

  Future<void> updateLikeCounter(
    String postId,
    bool isLike,
    int currentLikes,
  ) async {
    var user = AuthService().user!;
    int likeVal;
    if (isLike) {
      likeVal = 1;
      var doc = _db.collection("users").doc(user.uid);
      await doc.update({
        "likedPosts": FieldValue.arrayUnion([postId])
      });
    } else {
      likeVal = -1;
      var doc = _db.collection("users").doc(user.uid);
      await doc.update({
        "likedPosts": FieldValue.arrayRemove([postId])
      });
    }
    var likeFinal = currentLikes + likeVal;
    await _db.collection("posts").doc(postId).update({"likes": likeFinal});
  }

  Future<void> postComment(String text, String postId, UserDetails user) async {
    var ref = _db.collection("posts").doc(postId).collection("comments");
    var comment = {
      'uid': user.uid,
      'postedAt': Timestamp.now(),
      'text': text,
      'userName': user.userName,
      'userPhoto': user.userPhoto
    };

    await ref.add(comment);
  }

  Future<List<PostComment>> getPostComments(String postId) async {
    var ref = _db.collection('posts').doc(postId).collection("comments");
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var comments = data.map((d) => PostComment.fromJson(d));
    return comments.toList();
  }

// **************************************************************************
// POSTS RELATED FUNCTIONS (END)
// **************************************************************************

// **************************************************************************
// USER RELATED FUNCTIONS
// **************************************************************************

  Future<List<UserDetails>> getUsersData(List uids) async {
    var ref = _db.collection('users');
    var snapshot = await ref.where(FieldPath.documentId, whereIn: uids).get();
    var data = snapshot.docs.map((s) => s.data());
    var users = data.map((d) => UserDetails.fromJson(d));
    return users.toList();
  }

  Future<UserDetails> getUserData(String uid) async {
    var ref = _db.collection('users').doc(uid);
    var snapshot = await ref.get();
    var data = snapshot.data();
    var user = UserDetails.fromJson(data!);
    return user;
  }

  Future<void> updateNotificationCounter(String uid, bool increment) async {
    var doc = _db.collection("users").doc(uid);
    if (increment) {
      await doc.update({"notifications": FieldValue.increment(1)});
    } else {
      await doc.update({"notifications": 0});
    }
  }

  Future<void> createUserData(String uid) {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);

    var data = {
      'uid': user.uid,
      'userPhoto': user.photoURL,
      'userName': user.displayName,
      'isVerified': user.emailVerified,
      'bio': "You might want to change this",
      'likedPosts': [],
      'notifications': 0,
      'contacts': [],
      'history': [],
      'interests': []
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> createUserDataForEmail(String uid, String name) {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);

    var data = {
      'uid': user.uid,
      'userPhoto':
          "https://imgs.search.brave.com/KbRNVWFimWUnThr3tB08-RFa0i7K1uc-zlK6KQedwUU/rs:fit:860:752:1/g:ce/aHR0cHM6Ly93d3cu/a2luZHBuZy5jb20v/cGljYy9tLzI0LTI0/ODI1M191c2VyLXBy/b2ZpbGUtZGVmYXVs/dC1pbWFnZS1wbmct/Y2xpcGFydC1wbmct/ZG93bmxvYWQucG5n",
      'userName': name,
      'isVerified': user.emailVerified,
      'bio': "You might want to change this",
      'likedPosts': [],
      'notifications': 0,
      'contacts': [],
      'history': [],
      'interests': []
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateSkills(List skills) async {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);

    var data = {
      "skills": skills,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updatIsVerified(bool isVerified) async {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);

    var data = {
      "isVerified": isVerified,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateUserPhoto(String photoUrl) async {
    var user = AuthService().user!;
    var ref = _db.collection("users").doc(user.uid);

    var data = {
      "userPhoto": photoUrl,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateUserContacts(String uidOfOtherUser) async {
    var user = AuthService().user!;
    var ref = _db.collection("users").doc(user.uid);

    var data = {
      'contacts': FieldValue.arrayUnion([uidOfOtherUser]),
    };

    await ref.set(data, SetOptions(merge: true));
  }

  Stream<UserDetails> streamCurrentUserData() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('users').doc(user.uid);
        return ref.snapshots().map((doc) => UserDetails.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([UserDetails()]);
      }
    });
  }

// **************************************************************************
// USER RELATED FUNCTIONS (END)
// **************************************************************************

// **************************************************************************
// CHAT RELATED FUNCTIONS
// **************************************************************************

  Stream<List<ChatRoom>> streamChatRooms(String uid) {
    var ref = _db.collection("rooms");
    return ref
        .where("participants", arrayContains: uid)
        .orderBy("sentAt", descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => ChatRoom.fromJson(document.data()))
            .toList());
  }

  Future<Map> getChatRooms(uid) async {
    Map<String, dynamic> room = {};
    List arrayOfIds = [];
    var ref = _db.collection('rooms');
    await ref.where("participants", arrayContains: uid).get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          room["roomId"] = doc.id;
          arrayOfIds.add(doc["participants"]);
        }
        room["ids"] = arrayOfIds[0];
        arrayOfIds = [];
      },
    );
    return room;
  }

  Future<String> createChatRoom(String uid_1, String uid_2) async {
    List participants = [uid_1, uid_2];
    var room = _db.collection("rooms");
    var data = {"participants": participants};
    var newRoom = await room.add(data);
    var messages =
        _db.collection("rooms").doc(newRoom.id).collection("messages");
    final newMessage = {
      'uid': "",
      'text': "",
      'sentAt': Timestamp.now(),
    };
    final roomDetails = {
      'roomId': newRoom.id,
      'sentAt': Timestamp.now(),
      'text': ""
    };
    await messages.add(newMessage);
    await room.doc(newRoom.id).set(roomDetails, SetOptions(merge: true));
    return newRoom.id;
  }

  Future<void> uploadMessage(String roomId, String message) async {
    var user = AuthService().user!;
    final ref = _db.collection("rooms/$roomId/messages");
    final doc = _db.collection("rooms").doc(roomId);
    final newMessage = {
      'uid': user.uid,
      'text': message,
      'sentAt': Timestamp.now(),
    };

    await ref.add(newMessage);
    await doc.set(
        {"text": message, "sentAt": Timestamp.now()}, SetOptions(merge: true));
  }

  Stream<List<Message>> streamMessages(String roomId) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection("messages")
        .orderBy("sentAt", descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => Message.fromJson(document.data()))
            .toList());
  }

// **************************************************************************
// CHAT RELATED FUNCTIONS (END)
// **************************************************************************

// **************************************************************************
// BLOG RELATED FUNCTIONS
// **************************************************************************

  Stream<List<Blog>> streamBlogData() {
    return _db.collection('blogs').snapshots().map((snapShot) => snapShot.docs
        .map((document) => Blog.fromJson(document.data()))
        .toList());
  }
  // **************************************************************************
  // BLOG RELATED FUNCTIONS (END)
  // **************************************************************************

  void getPermisions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<List<Tag>> getLimitTags() async {
    var ref = _db
        .collection('interestTags')
        .orderBy("numberOfPosts", descending: true)
        .limit(5);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tags = data.map((d) => Tag.fromJson(d));
    return tags.toList();
  }

  Future<List<Tag>> getAllTags() async {
    var ref = _db
        .collection('interestTags')
        .orderBy("numberOfPosts", descending: true);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tags = data.map((d) => Tag.fromJson(d));
    return tags.toList();
  }
}
