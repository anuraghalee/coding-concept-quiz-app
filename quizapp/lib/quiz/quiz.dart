import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz_state.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/loader.dart';
import 'package:quizapp/shared/progress_bar.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder<Quiz>(
        future: FireStore().getQuiz(quizId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var quiz = snapshot.data!;
            return FutureBuilder(
              future: Future.delayed(
                const Duration(seconds: 2),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var state = Provider.of<QuizState>(context);
                  return Scaffold(
                    appBar: AppBar(
                      title: AppProgressBar(
                        value: state.value,
                      ),
                      leading: IconButton(
                        icon: const Icon(FontAwesomeIcons.xmark),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: state.con,
                        onPageChanged: (value) {
                          state.value = (value) / (quiz.questions.length + 1);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return StartPage(quiz: quiz);
                          } else if (index == quiz.questions.length + 1) {
                            return EndPage(quiz: quiz);
                          } else {
                            return QuestionPage(
                              question: quiz.questions[index - 1],
                              ind: index,
                              val: quiz.questions.length,
                            );
                          }
                        }),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Loader();
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            child: Text(
              quiz.title,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.yellow.shade800,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 40),
            width: double.infinity,
            child: Opacity(
              opacity: 0.8,
              child: Text(
                quiz.description,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                state.nextpage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.8),
                elevation: 20,
                shadowColor: Colors.black.withOpacity(0.8),
              ),
              child: const Text(
                'Start Quiz',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class EndPage extends StatelessWidget {
  const EndPage({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Text(
              'Congrats! You have completed the ${quiz.title} quiz.',
              style: const TextStyle(
                fontSize: 25,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            child: Image.asset('assets/congrats.gif'),
          ),
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Mark Complete!',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                FireStore().updateReport(quiz);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'topic',
                  (route) => false,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage(
      {super.key,
      required this.question,
      required this.ind,
      required this.val});
  final Question question;
  final int ind;
  final int val;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white.withOpacity(1),
                ),
                children: [
                  TextSpan(text: 'Question ${ind.toString().padLeft(2, '0')}'),
                  TextSpan(
                    text: '/${val.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              children: question.options.map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 80,
                    child: Card(
                      color: Colors.grey.withOpacity(.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(
                          width: 1.2,
                          color: Colors.grey,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          state.option = e;
                          _bottomsheet(context, e, state);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 5),
                          child: Row(
                            children: [
                              Icon(
                                state.option == e
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.circle,
                                color: Colors.grey.shade400,
                                size: 15,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    e.value,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  //Pop-Up Screen when question is answered.
  _bottomsheet(BuildContext context, Option e, QuizState state) {
    bool val = e.correct;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            border: Border.all(color: Colors.white),
            color: val
                ? const Color.fromRGBO(176, 224, 123, 0.8)
                : const Color.fromRGBO(255, 135, 137, 0.7),
          ),
          height: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  val == true ? 'Good Job!' : 'Ooops!',
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 10,
                  right: 10,
                ),
                width: double.infinity,
                child: Text(
                  e.detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 60,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (val) {
                      state.nextpage();
                    }
                    Navigator.pop(context);
                  },
                  child: val == true
                      ? const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 26,
                            letterSpacing: 0.6,
                            color: Color.fromRGBO(176, 224, 123, 0.8),
                          ),
                        )
                      : const Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 26,
                            letterSpacing: 0.6,
                            color: Color.fromRGBO(255, 135, 137, 0.7),
                          ),
                        ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
