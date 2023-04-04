import 'package:flutter/material.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import 'package:quizapp/shared/loader.dart';
import 'package:quizapp/topic/drawer.dart';
import 'package:quizapp/topic/topicitem.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore().getTopic(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var topic = snapshot.data!;
          return FutureBuilder(
            future: Future.delayed(
              const Duration(seconds: 3),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Topics Screen'),
                    backgroundColor: Colors.black,
                  ),
                  drawer: AppTopicDrawer(topics: topic),
                  body: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: topic.map((e) => TopicItem(topic: e)).toList(),
                  ),
                  bottomNavigationBar: const BottomNavBar(),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else {
                return Container();
              }
            },
          );
        } else {
          return const Center(
            child: SizedBox(),
          );
        }
      },
    );
  }
}
