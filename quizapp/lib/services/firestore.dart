import 'dart:async';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class FireStore {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch Topics.
  Future<List<Topic>> getTopic() async {
    var ref = _db.collection('topics');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((e) => e.data());
    var topics = data.map((e) => Topic.fromJson(e)).toList();
    // print(topics[0].title);
    return topics;
  }

  //Fetch a particular Quiz.
  Future<Quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    var quiz = Quiz.fromJson(snapshot.data() ?? {});
    return quiz;
  }

  //Fetch report for particular user.
  Stream<Report> getReport() {
    return AuthService().userStream.switchMap((value) {
      if (value != null) {
        var ref = _db.collection('reports').doc(value.uid);
        return ref.snapshots().map((event) => Report.fromJson(event.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  //Write data to firestore i.e. update the database with changes.
  Future<void> updateReport(Quiz quiz) {
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      },
    };

    return ref.set(data, SetOptions(merge: true));
  }
}
