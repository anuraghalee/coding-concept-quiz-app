import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(
              child: FlutterLogo(
                size: 100,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginButton(
                    color: Colors.purple.withOpacity(0.5),
                    icon: FontAwesomeIcons.userNinja,
                    text: 'Continue as Guest',
                    logMethod: AuthService().anonLogin,
                  ),
                  LoginButton(
                    color: Colors.blue.withOpacity(0.5),
                    icon: FontAwesomeIcons.google,
                    text: 'Continue with Google',
                    logMethod: AuthService().gSignIn,
                  ),
                  LoginButton(
                    color: Colors.black.withOpacity(0.5),
                    icon: FontAwesomeIcons.apple,
                    text: 'Continue with Apple',
                    logMethod: AuthService().anonLogin,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function logMethod;

  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.logMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          await logMethod();
        },
        style: TextButton.styleFrom(
          backgroundColor: color,
          fixedSize: const Size(0, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          side: BorderSide(
            width: 2,
            color: color,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
