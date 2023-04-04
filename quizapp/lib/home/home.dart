import 'package:flutter/material.dart';
import 'package:quizapp/login/login.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/shared/loader.dart';
import 'package:quizapp/topic/topic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else if (snapshot.hasData) {
          return const TopicScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
