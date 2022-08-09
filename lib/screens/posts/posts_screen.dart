import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:studhub/services/models.dart';
import 'package:studhub/shared/bottom_nav.dart';
import 'package:studhub/services/firestore.dart';
import 'package:studhub/widgets/post_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/error.dart';
import '../../shared/loading.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) FirestoreService().getPermisions();
    return StreamBuilder<List<Post>>(
      stream: FirestoreService().streamPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var posts = snapshot.data!;

          return Scaffold(
            appBar: const PreferredSize(
              child: MainAppBar(),
              preferredSize: Size.fromHeight(60),
            ),
            body: ListView(
              primary: true,
              padding: const EdgeInsets.all(20.0),
              children: posts.map((posts) => PostWidget(post: posts)).toList(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange,
              child: const Icon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.pushNamed(context, '/post_create');
              },
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        } else {
          return const Text('No posts found in database.');
        }
      },
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black38,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/Logo_conver.png",
            width: 120,
            height: 120,
          ),
          Badge(
            badgeContent: const Text('2'),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              icon: const Icon(
                FontAwesomeIcons.comment,
                color: Colors.orange,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
