import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const AppProgressBar({super.key, required this.value, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
      return Container(
        padding: const EdgeInsets.only(right: 5, left: 5, bottom: 0),
        width: box.maxWidth,
        child: Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  )),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCirc,
              height: height,
              width: box.maxWidth * (value),
              decoration: BoxDecoration(
                  color: colorgen(value),
                  borderRadius: BorderRadius.all(Radius.circular(height))),
            )
          ],
        ),
      );
    });
  }
}

class TopicProgress extends StatelessWidget {
  final Topic topic;

  const TopicProgress({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          progresscount(topic, report),
          Expanded(
            child: AppProgressBar(
              value: calcProgress(topic, report),
              height: 8,
            ),
          )
        ],
      ),
    );
  }
}

Widget progresscount(Topic topic, Report report) {
  return Padding(
    padding: const EdgeInsets.only(left: 5),
    child: Text(
        '${report.topics[topic.id]?.length ?? '0'}/${topic.quizzes.length}'),
  );
}

double calcProgress(Topic topic, Report report) {
  try {
    int com = report.topics[topic.id].length;
    int tot = topic.quizzes.length;
    return com / tot;
  } catch (err) {
    return 0;
  }
}

colorgen(double value) {
  int rgb = (value * 255).toInt();
  return Colors.deepOrange.withGreen(rgb).withRed(255 - rgb);
}
