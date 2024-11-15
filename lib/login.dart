import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Method to handle Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: '193034358656-oh0oliqft2pubpm8fks6clio2rbac12c.apps.googleusercontent.com',
      ).signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        print("Signed in with Google.");
        // Navigate back to the previous screen on successful sign-in
        if (context.mounted) context.pop();
      }
    } catch (e) {
      print("Google sign-in failed: $e");
    }

    //register user
  }

  // Method to handle anonymous sign-in with error handling
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with a temporary account.");
      // Navigate back to the previous screen on successful sign-in
      if (context.mounted) context.pop();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error: ${e.message}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }

    //register user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FilledButton(
                onPressed: signInWithGoogle,
                child: const Text("Google"),
              ),
              const SizedBox(height: 16.0),
              FilledButton(
                onPressed: signInAnonymously,
                child: const Text("Guest"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}