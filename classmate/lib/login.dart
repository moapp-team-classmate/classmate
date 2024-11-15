import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> registerUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Ensure the user is logged in
    if (currentUser == null) {
      print("No user is currently logged in.");
      return;
    }

    final userId = currentUser.uid;
    final userCollection = FirebaseFirestore.instance.collection('users');

    try {
      // Check if the user document already exists
      final querySnapshot = await userCollection.where('uid', isEqualTo: userId).get();

      if (querySnapshot.docs.isEmpty) {
        // Reference to the new user document
        final userDocRef = userCollection.doc(userId);

        // Ask for the user's name if they sign in for the first time
        final userName = await _askForName();

        // Set up the user data depending on login method
        final userData = {
          'uid': userId,
          'status_message': 'I promise to take the test honestly before GOD.',
          'cart': [],
          'email': currentUser.email,
          'name': userName ?? currentUser.displayName,
        };

        // Create a new document for the user
        await userDocRef.set(userData);
        print("New user document created for ID: $userId");
      } else {
        print("User document already exists for ID: $userId");
      }
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  // Method to ask for the user's name
  Future<String?> _askForName() async {
    String? userName;

    await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: Text("Enter your name"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Your Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                userName = nameController.text;
                Navigator.of(context).pop(); // Close the dialog and save the name
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );

    return userName;
  }

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
        
        // Register user in Firestore
        await registerUser();

        // Navigate back to the previous screen on successful sign-in
        if (context.mounted) context.pop();
      }
    } catch (e) {
      print("Google sign-in failed: $e");
    }
  }

  // Method to handle anonymous sign-in with error handling
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with a temporary account.");
      
      // Register user in Firestore
      await registerUser();

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