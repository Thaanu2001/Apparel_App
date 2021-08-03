import 'dart:io';

import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/services/dismiss_keyboard.dart';
import 'package:Apparel_App/screens/auth/sign_up_screen.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';

class EmailSignInScreen extends StatefulWidget {
  final Route route;
  EmailSignInScreen({required this.route});

  @override
  _EmailSignInScreenState createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool termsAccept = false;
  bool _obscurePassword = true;
  bool authOnProgress = false;

  //* Show password
  void _showPassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    error = false;
  }

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
              padding: EdgeInsets.fromLTRB(
                  0, (Platform.isAndroid) ? 35 : 50, 20, 10),
              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: InkWell(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 32,
                  color: Color(0xff646464),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            //* Sign in Topic --------------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 15),
              child: Text(
                'Sign in',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //* Email textfield ---------------------------------------------------------
                    TextField(
                      controller: email,
                      autofillHints: [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: new InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(fontFamily: 'sf', color: Colors.black),
                        // filled: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: 15),
                    //* Password textfield ---------------------------------------------------------
                    TextField(
                      controller: password,
                      autofillHints: [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      obscureText: _obscurePassword,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: new InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(fontFamily: 'sf', color: Colors.black),
                        // filled: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.black, width: 1.5),
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
                    (error)
                        ? Container(
                            //* Error message Text -------------------------------------------------------------------------------
                            padding: EdgeInsets.fromLTRB(0, 5, 30, 10),
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
                        : SizedBox(height: 15),
                    //* Sign in with Email button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black,
                          primary: Colors.grey,
                        ),
                        onPressed: () async {
                          dismissKeyboard(context);
                          if (email.text == '' || password.text == '') {
                            errorMessage = 'Enter your email and password';
                            error = true;
                          } else {
                            setState(() {
                              authOnProgress = true;
                            });

                            await AuthService().signIn(
                              email.text,
                              password.text,
                              context,
                              widget.route,
                            );
                          }
                          setState(() {
                            authOnProgress = false;
                          });
                        },
                        child: (!authOnProgress)
                            ? Text(
                                "Sign in",
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
                    SizedBox(height: 8),
                    Container(
                      //* Password reset Button ----------------------------------------------------------------------------------
                      margin: EdgeInsets.fromLTRB(30, 5, 30, 8),
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 5, 30, 8),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        //* Create Account Button ----------------------------------------------------------------------------------
                        margin: EdgeInsets.fromLTRB(
                            30, 5, 30, (Platform.isAndroid) ? 30 : 50),
                        child: InkWell(
                          child: Text(
                            'Create an account',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Route route = SlideLeftTransition(
                              widget: SignUpScreen(route: widget.route),
                            );
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      ),
                    ),
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
