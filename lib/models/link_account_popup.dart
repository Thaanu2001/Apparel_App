import 'package:Apparel_App/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/services/auth_service.dart';

//* Link accounts popup ------------------------------------------------------------------------
linkAccountPopup(
    {required context,
    email,
    onPressed,
    isPassword,
    pendingCredential,
    route,
    signInMethod}) {
  bool _obscurePassword = true;
  bool processingLink = false;
  final _linkPassword = TextEditingController();

  error = false;

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
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                //* Show Password
                void _showPassword() {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }

                return Column(
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
                        (isPassword)
                            ? 'User with this email address already exists.\nPlease enter your password to link your $signInMethod account'
                            : 'User with this email address already exists. Do you want to link it to your $signInMethod account?',
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    //* Password textfield ---------------------------------------------------------
                    if (isPassword)
                      Container(
                        padding: EdgeInsets.only(right: 20, bottom: 0, top: 10),
                        child: TextField(
                          controller: _linkPassword,
                          obscureText: _obscurePassword,
                          autofillHints: [AutofillHints.password],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          decoration: new InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontFamily: 'sf', color: Colors.black),
                            // filled: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            isDense: true,
                            suffixIcon: InkWell(
                              onTap: _showPassword,
                              child: Icon(
                                _obscurePassword
                                    ? Customicons.eye_off
                                    : Customicons.eye,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              maxHeight: 20,
                            ),
                          ),
                        ),
                      ),
                    (isPassword)
                        ? (error)
                            //* Error message Text -------------------------------------------------------------------------------
                            ? Container(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : SizedBox(height: 13)
                        : SizedBox(height: 10),
                    //* Link account button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(right: 20),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.grey,
                          backgroundColor: mainAccentColor,
                        ),
                        onPressed: (isPassword)
                            ? () async {
                                setState(() {
                                  processingLink = true;
                                });
                                try {
                                  // Sign the user in to their account with the password
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                    email: email,
                                    password: _linkPassword.text,
                                  );

                                  // Link the pending credential with the existing account
                                  final UserCredential userData =
                                      await userCredential.user!
                                          .linkWithCredential(
                                              pendingCredential);

                                  AuthService().checkUser(userData: userData);

                                  Navigator.pop(context);
                                  (route != null)
                                      ? Navigator.pushReplacement(
                                          context, route)
                                      : Navigator.pop(context);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'wrong-password') {
                                    errorMessage = 'Wrong password.';
                                    error = true;
                                  }
                                }
                                setState(() {
                                  processingLink = false;
                                });
                              }
                            : () async {
                                setState(() {
                                  processingLink = true;
                                });

                                await onPressed();

                                setState(() {
                                  processingLink = false;
                                });
                              },
                        child: (!processingLink)
                            ? Text(
                                "Link your accounts",
                                style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
