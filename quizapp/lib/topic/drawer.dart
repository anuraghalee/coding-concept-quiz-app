import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz.dart';
import 'package:quizapp/services/models.dart';

class AppTopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  const AppTopicDrawer({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          var topic = topics[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              QuizList(topic: topic),
            ],
          );
        }),
        separatorBuilder: ((context, index) {
          return const Divider(
            color: Colors.white12,
            thickness: 2,
          );
        }),
        itemCount: topics.length,
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;
  const QuizList({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topic.quizzes.map((e) {
        return Card(
          elevation: 10,
          margin: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => QuizScreen(quizId: e.id),
              ));
            }),
            child: Container(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: ListTile(
                  title: Text(e.title),
                  subtitle: Text(
                    e.description,
                    style: const TextStyle(fontSize: 12),
                  ),
                  leading: QuizBadge(topic: topic, quizId: e.id),
                )),
          ),
        );
      }).toList(),
    );
  }
}

class QuizBadge extends StatelessWidget {
  const QuizBadge({super.key, required this.topic, required this.quizId});

  final Topic topic;
  final String quizId;

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    List completed = report.topics[topic.id] ?? [];
    String str = completed.map((e) => e.toString()).join('-');

    if (str.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}
