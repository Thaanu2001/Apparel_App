import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Apparel_App/widgets/link_account_popup.dart';

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

  signUp(email, password, name, context, route) async {
    //* User Sign Up ----------------------------------------------------------------------------------------------------
    try {
      final UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user.user.updateProfile(displayName: name);

      if (user != null) {
        checkUser(userData: user, name: name);
        Navigator.pop(context);
        Navigator.pushReplacement(context, route);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        error = true;
      } else if (e.code == 'email-already-in-use') {
        List<String> userSignInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if (userSignInMethods.contains('password')) {
          errorMessage = 'The account already exists.';
          error = true;
        } else if (userSignInMethods.first == 'facebook.com') {
          //* Link with facebook account
          await linkAccountPopup(
            context: context,
            email: email,
            signInMethod: 'email',
            isPassword: false,
            onPressed: () async {
              // Trigger the authentication flow
              final AccessToken result = await FacebookAuth.instance.login();

              // Create a credential from the access token
              final FacebookAuthCredential facebookAuthCredential =
                  FacebookAuthProvider.credential(result.token);

              // Once signed in, return the UserCredential
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithCredential(facebookAuthCredential);

              AuthCredential pendingCredential = EmailAuthProvider.credential(
                  email: email, password: password);

              // Link the pending credential with the existing account
              final UserCredential userData = await userCredential.user
                  .linkWithCredential(pendingCredential);

              checkUser(userData: userData);

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(context, route);
            },
          );
        } else if (userSignInMethods.first == 'google.com') {
          //* Link with google account
          await linkAccountPopup(
            context: context,
            email: email,
            signInMethod: 'email',
            isPassword: false,
            onPressed: () async {
              // Trigger the authentication flow
              final GoogleSignInAccount googleUser =
                  await GoogleSignIn().signIn();

              // Obtain the auth details from the request
              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;

              // Create a new credential
              final GoogleAuthCredential credential =
                  GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              // Once signed in, return the UserCredential
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);

              AuthCredential pendingCredential = EmailAuthProvider.credential(
                  email: email, password: password);

              // Link the pending credential with the existing account
              final UserCredential userData = await userCredential.user
                  .linkWithCredential(pendingCredential);

              checkUser(userData: userData);

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(context, route);
            },
          );
        }
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email provided is invalid';
        error = true;
      }
    } catch (e) {
      print(e);
    }
  }

  signIn(email, password, context, route) async {
    //* User Log In ----------------------------------------------------------------------------------------------------
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        print(user);
        checkUser(userData: user);
        Navigator.pop(context);
        Navigator.pushReplacement(context, route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        print('here');
        errorMessage = 'No user found for this email.';
        error = true;
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password.';
        error = true;
      }
    }
  }

  signOut(context) async {
    //* Sign Out ----------------------------------------------------------------------------------------------------------
    print(FirebaseAuth.instance.currentUser.providerData[0].providerId);
    // if (FirebaseAuth.instance.currentUser.providerData[0].providerId ==
    //     'google.com') await GoogleSignIn().disconnect();

    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  //* Sign In with Google ---------------------------------------------------------------------------
  signInWithGoogle(context, route) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    List<String> userSignInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(googleUser.email);

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential pendingCredential =
        GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(userSignInMethods);
    //* Link with Email & Password account
    if (userSignInMethods.isEmpty || userSignInMethods.contains('google.com')) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(pendingCredential);
      checkUser(userData: userCredential);
      Navigator.pushReplacement(context, route);
    } else if (userSignInMethods.first == 'password') {
      await linkAccountPopup(
        context: context,
        email: googleUser.email,
        isPassword: true,
        pendingCredential: pendingCredential,
        route: route,
        signInMethod: 'Google',
      );
      //* Link with facebook account
    } else if (userSignInMethods.first == 'facebook.com') {
      await linkAccountPopup(
        context: context,
        email: googleUser.email,
        signInMethod: 'Google',
        isPassword: false,
        onPressed: () async {
          // Trigger the authentication flow
          final AccessToken result = await FacebookAuth.instance.login();

          // Create a credential from the access token
          final FacebookAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.token);

          // Once signed in, return the UserCredential
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          // Link the pending credential with the existing account
          final UserCredential userData =
              await userCredential.user.linkWithCredential(pendingCredential);

          checkUser(userData: userData);

          Navigator.pop(context);
          Navigator.pushReplacement(context, route);
        },
      );
    }
  }

  //* Sign in with Facebook ----------------------------------------------------------------------------
  signInWithFacebook(context, route) async {
    try {
      // Trigger the sign-in flow
      final AccessToken result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      checkUser(userData: userCredential);
      Navigator.pushReplacement(context, route);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // The account already exists with a different credential
        String email = e.email;
        AuthCredential pendingCredential = e.credential;

        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        // If the user has several sign-in methods,
        // the first method in the list will be the "recommended" method to use.
        //* Link with Email & Password account
        if (userSignInMethods.first == 'password') {
          await linkAccountPopup(
            context: context,
            email: email,
            isPassword: true,
            pendingCredential: pendingCredential,
            route: route,
            signInMethod: 'Facebook',
          );
        }

        //* Link with Google account
        if (userSignInMethods.first == 'google.com') {
          await linkAccountPopup(
            context: context,
            email: email,
            isPassword: false,
            signInMethod: 'Facebook',
            onPressed: () async {
              // Trigger the authentication flow
              final GoogleSignInAccount googleUser =
                  await GoogleSignIn().signIn();

              // Obtain the auth details from the request
              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;

              // Create a new credential
              final GoogleAuthCredential credential =
                  GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              // Once signed in, return the UserCredential
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);

              // Link the pending credential with the existing account
              final UserCredential userData = await userCredential.user
                  .linkWithCredential(pendingCredential);

              checkUser(userData: userData);

              Navigator.pop(context);
              Navigator.pushReplacement(context, route);
            },
          );
        }
      }
    }
  }

  //* Update user data in firestore -------------------------------------------------------------
  checkUser({userData, name}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userData.user.uid)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) async {
        if (!documentSnapshot.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userData.user.uid)
              .set({
            'name': (userData.user.displayName != null)
                ? userData.user.displayName
                : name,
            'email': userData.user.email,
            'phone-number': userData.user.phoneNumber,
            'account-created': DateTime.now(),
            'last-signin': DateTime.now()
          });
        } else {
          print('heree');
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userData.user.uid)
              .update(
            {
              'last-signin': DateTime.now(),
            },
          );
        }
      },
    );
  }
}
