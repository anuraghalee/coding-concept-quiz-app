import 'package:quizapp/about/about.dart';
import 'package:quizapp/home/home.dart';
import 'package:quizapp/login/login.dart';
import 'package:quizapp/topic/topic.dart';
import 'package:quizapp/profile/profile.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  'about': (context) => const AboutScreen(),
  'login': (context) => const LoginScreen(),
  'topic': (context) => const TopicScreen(),
  'profile': (context) => const ProfileScreen()
};
