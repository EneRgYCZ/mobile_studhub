import 'package:flutter/material.dart';
import 'package:studhub/login/login.dart';
import 'package:studhub/posts/posts.dart';
import 'package:studhub/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error..."),
          );
        } else if (snapshot.hasData) {
          return const PostsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
