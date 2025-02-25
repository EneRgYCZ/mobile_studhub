import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studhub/services/models.dart';
import 'package:studhub/services/firestore.dart';
import 'package:studhub/widgets/post/post_list_widget.dart';

import '../../shared/error.dart';
import '../../shared/loading.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    var userExtraData = Provider.of<UserDetails>(context);

    FirebaseMessaging.onMessage.listen((event) {
      FirestoreService().updateNotificationCounter(userExtraData.uid, true);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.pushNamed(context, '/chat');
    });
    return StreamBuilder<List<Post>>(
      stream: FirestoreService().streamPosts(userExtraData.interests),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var posts = snapshot.data!;
          return PostListWidget(posts: posts, user: userExtraData);
        } else {
          return const Text('No posts was found in database.');
        }
      },
    );
  }
}
