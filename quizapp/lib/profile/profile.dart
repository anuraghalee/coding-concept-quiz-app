import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/auth.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    User? user = AuthService().user;
    var count = report.total;
    String? name;

    var topicList = report.topics.keys.toList();
    String? str = topicList.map((e) => e.toString()).join(' , ');

    Avatar avatar = DiceBearBuilder.withRandomSeed(
      sprite: DiceBearSprite.bottts,
      scale: 100,
    ).build();

    if (user != null) {
      if (user.isAnonymous) {
        name = 'Guest';
      } else {
        name = user.displayName;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'User Profile',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await AuthService().signOut();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                }
              },
              icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  // width: 300,
                  // height: 400,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: Colors.teal.shade100,
                  // ),
                  child: name == "Guest"
                      ? CircleAvatar(
                          radius: 140,
                          backgroundColor: Colors.cyan.withOpacity(0.5),
                          child: avatar.toImage(),
                        )
                      : ClipOval(
                          child: CircleAvatar(
                            radius: 140,
                            child: Image.network(
                              user.photoURL!.replaceAll("s96-c", "s2048-k"),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: 450,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shadowColor: Colors.cyan,
                        color: Colors.cyan.withOpacity(0.5),
                        elevation: 30,
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            'Name : $name',
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: Card(
                        shadowColor: Colors.cyan,
                        color: Colors.cyan.withOpacity(0.5),
                        elevation: 30,
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                            left: 10,
                            right: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Topics Covered: ',
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                str.isEmpty ? 'None' : str,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: Card(
                        shadowColor: Colors.cyan,
                        color: Colors.cyan.withOpacity(0.6),
                        elevation: 30,
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            'Quiz Count : $count',
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text('User Not Logged-in'),
      );
    }
  }
}
