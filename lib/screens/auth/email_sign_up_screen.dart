import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/screens/auth/sign_in_screen.dart';
import 'package:Apparel_App/transitions/sliding_transition.dart';

class EmailSignUpScreen extends StatefulWidget {
  final Route route;
  EmailSignUpScreen({@required this.route});

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool termsAccept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                child: Icon(Icons.arrow_back),
                onTap: () => Navigator.pop(context),
              ),
            ),
            //* Sign up Topic --------------------------------------------------------------------
            Container(
              // alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
              child: Text(
                'Create an account',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 20,
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
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 15,
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
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 15,
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
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 15,
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
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 15,
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
                      ),
                    ),
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
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        highlightColor: Color(0xff2e2e2e),
                        color: Colors.black,
                        onPressed: () {},
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
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
