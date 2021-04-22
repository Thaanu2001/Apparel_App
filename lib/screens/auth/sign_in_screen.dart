import 'package:Apparel_App/screens/auth/email_sign_in_screen.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/screens/auth/sign_up_screen.dart';
import 'package:Apparel_App/transitions/sliding_transition.dart';

class SignInScreen extends StatefulWidget {
  final Route route;
  SignInScreen({@required this.route});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 30, 20, 10),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: InkWell(
                child: Icon(Icons.close),
                onTap: () => Navigator.pop(context),
              ),
            ),
            //* Sign in Topic --------------------------------------------------------------------
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'Sign in',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
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
                    //* Sign in with Email button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        highlightColor: Color(0xff2e2e2e),
                        color: Colors.black,
                        onPressed: () {
                          Route route = SlidingTransition(
                            widget: EmailSignInScreen(route: widget.route),
                          );
                          Navigator.push(context, route);
                        },
                        child: Text(
                          "Sign in with Email",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Divider(
                      height: 30,
                      thickness: 1,
                    ),
                    //* Sign in with google button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black, width: 2)),
                        highlightColor: Color(0xffe4e4e4),
                        // color: Colors.black,
                        onPressed: () async {
                          await AuthService()
                              .signInWithGoogle(context, widget.route);
                        },
                        child: Row(
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
                              'Sign in with Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              //width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //* Sign in with facebook button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black, width: 2)),
                        highlightColor: Color(0xffe4e4e4),
                        onPressed: () async {
                          await AuthService()
                              .signInWithFacebook(context, widget.route);
                        },
                        child: Row(
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
                              'Sign in with Facebook',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              //width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      //* Sign Up Button ----------------------------------------------------------------------------------
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(30, 5, 30, 8),
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 8),
                          child: Text(
                            'Don\'t have an account?\nSign up',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          Route route = SlidingTransition(
                            widget: SignUpScreen(route: widget.route),
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
