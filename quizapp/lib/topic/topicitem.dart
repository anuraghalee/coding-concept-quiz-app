import 'package:flutter/material.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/progress_bar.dart';
import 'package:quizapp/topic/drawer.dart';

class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: topic.img,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 700),
                reverseTransitionDuration: const Duration(milliseconds: 400),
                pageBuilder: ((context, animation, secondaryAnimation) =>
                    TopicItemScreen(topic: topic)),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/covers/${topic.img}',
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Center(
                  child: Text(
                    topic.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Flexible(
                child: TopicProgress(
                  topic: topic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopicItemScreen extends StatelessWidget {
  final Topic topic;

  const TopicItemScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            child: Stack(children: [
              Hero(
                tag: topic.img,
                child: Image.asset(
                  'assets/covers/${topic.img}',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fill,
                ),
                placeholderBuilder: (context, heroSize, child) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 195,
                    child: const CircularProgressIndicator(
                      color: Colors.lightBlueAccent,
                    ),
                  );
                },
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: QuizList(topic: topic),
          )
        ],
      ),
    );
  }
}
