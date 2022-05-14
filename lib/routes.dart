import 'package:studhub/chat/chat.dart';
import 'package:studhub/home/home.dart';
import 'package:studhub/posts/post_create.dart';
import 'package:studhub/posts/posts.dart';
import 'package:studhub/login/login.dart';
import 'package:studhub/thread/thread.dart';
import 'package:studhub/profile/profile.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/chat': (context) => const ChatScreen(),
  '/login': (context) => const LoginScreen(),
  '/posts': (context) => const PostsScreen(),
  '/threads': (context) => const ThreadScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/post_create': (context) => const PostCreateScreen(),
};
