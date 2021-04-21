import 'package:Apparel_App/screens/home_screen.dart';
import 'package:Apparel_App/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool error = false;
String errorMessage = '';

class AuthService {
  // handleAuth() {
  //   //* Handles Auth ---------------------------------------------------------------------------------------------------
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.hasData) {
  //         return HomeScreen();
  //       } else {
  //         return SignInScreen();
  //       }
  //     },
  //   );
  // }

  // signIn(email, password, context) async {
  //   //* User Sign In ----------------------------------------------------------------------------------------------------
  //   try {
  //     final user = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     if (user != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation1, animation2) => GadgetDoctor(),
  //           transitionDuration: Duration(seconds: 0),
  //         ),
  //       );
  //       dismissKeyboard(context);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       errorMessage = 'The password provided is too weak.';
  //       error = true;
  //     } else if (e.code == 'email-already-in-use') {
  //       errorMessage = 'The account already exists.';
  //       error = true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // logIn(email, password, context) async {
  //   //* User Log In ----------------------------------------------------------------------------------------------------
  //   try {
  //     final user = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //     if (user != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation1, animation2) => GadgetDoctor(),
  //           transitionDuration: Duration(seconds: 0),
  //         ),
  //       );
  //       dismissKeyboard(context);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       errorMessage = 'No user found for that email.';
  //       error = true;
  //     } else if (e.code == 'wrong-password') {
  //       errorMessage = 'Wrong password provided for that user.';
  //       error = true;
  //     }
  //   }
  // }

  signOut(context) async {
    //* Sign Out ----------------------------------------------------------------------------------------------------------
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  Future<UserCredential> signInWithGoogle() async {
    //* Sign In with Google -----------------------------------------------------------------------------------------------
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
