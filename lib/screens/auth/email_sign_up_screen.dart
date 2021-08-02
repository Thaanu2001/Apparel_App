import 'dart:io';

import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/services/dismiss_keyboard.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/screens/auth/sign_in_screen.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';

class EmailSignUpScreen extends StatefulWidget {
  final Route route;
  EmailSignUpScreen({required this.route});

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final re_password = TextEditingController();
  bool termsAccept = false;
  bool _obscurePassword = true;

  //* Show Password
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
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: InkWell(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 32,
                  color: Color(0xff646464),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            //* Sign up Topic --------------------------------------------------------------------
            Container(
              // alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 10, 0, 15),
              child: Text(
                'Create an account',
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
                    //* First Name textfield ---------------------------------------------------------
                    TextField(
                      controller: firstName,
                      autofillHints: [AutofillHints.givenName],
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: new InputDecoration(
                        labelText: 'First Name',
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
                    //* Last Name textfield ---------------------------------------------------------
                    TextField(
                      controller: lastName,
                      autofillHints: [AutofillHints.familyName],
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: new InputDecoration(
                        labelText: 'Last Name',
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
                    //* Email textfield ---------------------------------------------------------
                    TextField(
                      controller: email,
                      autofillHints: [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                      autofillHints: [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
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
                    SizedBox(height: 15),
                    //* Password textfield ---------------------------------------------------------
                    TextField(
                      controller: re_password,
                      autofillHints: [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: new InputDecoration(
                        labelText: 'Re-Type Password',
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
                    (error)
                        ? Container(
                            //* Error message Text -------------------------------------------------------------------------------
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                        : Container(),
                    Container(
                      //* Terms Service message ----------------------------------------------------------------------------------
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          // padding: EdgeInsets.fromLTRB(30, 5, 30, 8),
                          child: Text(
                            'By clicking Sign Up, you agree to our Terms of Service Policy.',
                            style: TextStyle(
                              fontFamily: 'sf',
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    SizedBox(height: 5),
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
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          dismissKeyboard(context);
                          if (firstName.text == '' ||
                              lastName.text == '' ||
                              email.text == '' ||
                              password.text == '') {
                            errorMessage = 'Please fill all the details';
                            error = true;
                          } else if (password.text != re_password.text) {
                            errorMessage = 'Passwords didn\'t match. Try again';
                            error = true;
                          } else {
                            await AuthService().signUp(
                              email.text.replaceAll(' ', ''),
                              password.text,
                              "${firstName.text} ${lastName.text}",
                              context,
                              widget.route,
                            );
                          }
                          setState(() {});
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
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
                            'Already have an account? Log in',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Route route = SlideLeftTransition(
                              widget: SignInScreen(route: widget.route),
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
