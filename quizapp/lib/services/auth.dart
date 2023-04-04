import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      // ignore: empty_catches
    } on FirebaseAuthException {}
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> gSignIn() async {
    try {
      final gUser = await GoogleSignIn().signIn();

      if (gUser == null) return;

      final userAuth = await gUser.authentication;

      final userCred = GoogleAuthProvider.credential(
        accessToken: userAuth.accessToken,
        idToken: userAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(userCred);
    } on FirebaseAuthException {}
  }
}
