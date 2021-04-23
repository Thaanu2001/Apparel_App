import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  signIn(email, password, name, context, route) async {
    //* User Sign In ----------------------------------------------------------------------------------------------------
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user.user.updateProfile(displayName: name);

      if (user != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        error = true;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists.';
        error = true;
      }
    } catch (e) {
      print(e);
    }
  }

  logIn(email, password, context, route) async {
    //* User Log In ----------------------------------------------------------------------------------------------------
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        error = true;
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
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

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    checkUser(userCredential);
    Navigator.pushReplacement(context, route);
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

      checkUser(userCredential);
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
        if (userSignInMethods.first == 'password') {
          // Prompt the user to enter their password
          String password = '...';

          // Sign the user in to their account with the password
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
        }

        //* Check email is already signed in with google
        if (userSignInMethods.first == 'google.com') {
          print(email);
          await popup(
            context: context,
            email: email,
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
              await userCredential.user.linkWithCredential(pendingCredential);
              Navigator.pop(context);
              Navigator.pushReplacement(context, route);
            },
          );
        }
      }
    }
  }

  //* Merge user dialog
  checkUser(userData) {
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
            'name': userData.user.displayName,
            'email': userData.user.email,
            'phone-number': userData.user.phoneNumber,
            'account-created': DateTime.now(),
            'last-signin': DateTime.now()
          });
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userData.user.uid)
              .update({'last-signin': DateTime.now()});
        }
      },
    );
  }

  popup({context, email, onPressed}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 1,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 15),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Close Button
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: InkWell(
                      child: Icon(Icons.close),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  //* Email
                  Text(
                    email,
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  //* Content
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'User with this email address already exists. Do you want to link it to your Facebook account?',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 8),
                  //* Sign in with Email button -------------------------------------------------------------------
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 20),
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      highlightColor: Color(0xff2e2e2e),
                      color: Colors.black,
                      onPressed: onPressed,
                      child: Text(
                        "Link your accounts",
                        style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
