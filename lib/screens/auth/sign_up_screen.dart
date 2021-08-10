import 'dart:io';

import 'package:Apparel_App/global_variables.dart';
import 'package:Apparel_App/screens/auth/email_sign_up_screen.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/screens/auth/sign_in_screen.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';

class SignUpScreen extends StatefulWidget {
  Route? route;
  SignUpScreen({this.route});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool authOnProgressGoogle = false;
  bool authOnProgressFacebook = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, (Platform.isAndroid) ? 35 : 50, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: InkWell(
                child: Icon(
                  Icons.close_rounded,
                  size: 32,
                  color: Color(0xff646464),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            //* Sign up Topic --------------------------------------------------------------------
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'Create an account',
                style: TextStyle(fontFamily: 'sf', fontSize: 26, color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            //* Main image ----------------------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 10),
              child: Image.asset('lib/assets/login_screen_image.webp'),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //* Sign up with Email button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.grey,
                          backgroundColor: mainAccentColor,
                        ),
                        onPressed: () {
                          Route route = SlideLeftTransition(
                            widget: EmailSignUpScreen(route: widget.route),
                          );
                          Navigator.push(context, route);
                        },
                        child: Text(
                          "Create with your Email",
                          style: TextStyle(
                              fontFamily: 'sf', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Divider(
                      height: 30,
                      thickness: 1,
                    ),
                    //* Sign up with google button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: mainAccentColor, width: 2)),
                          primary: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                        // color: Colors.black,
                        onPressed: () async {
                          setState(() {
                            authOnProgressGoogle = true;
                          });

                          await AuthService().signInWithGoogle(context, widget.route);

                          setState(() {
                            authOnProgressGoogle = false;
                          });
                        },
                        child: (!authOnProgressGoogle)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/assets/logos/google-logo.webp',
                                    width: 19,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Create with Google',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 18,
                                        color: mainAccentColor,
                                        fontWeight: FontWeight.w600),
                                    //width: double.infinity,
                                  ),
                                ],
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
                    //* Sign up with facebook button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: mainAccentColor, width: 2)),
                          primary: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          setState(() {
                            authOnProgressFacebook = true;
                          });

                          await AuthService().signInWithFacebook(context, widget.route);

                          setState(() {
                            authOnProgressFacebook = false;
                          });
                        },
                        child: (!authOnProgressFacebook)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/assets/logos/facebook-logo.webp',
                                    width: 19,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Create with Facebook',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 18,
                                        color: mainAccentColor,
                                        fontWeight: FontWeight.w600),
                                    //width: double.infinity,
                                  ),
                                ],
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
                    Container(
                      //* Sign Up Button ----------------------------------------------------------------------------------
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(30, 5, 30, 8),
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, (Platform.isAndroid) ? 15 : 30),
                          child: Text(
                            'Already have an account?\nSign in',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          Route route = SlideLeftTransition(
                            widget: SignInScreen(route: widget.route),
                          );
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
