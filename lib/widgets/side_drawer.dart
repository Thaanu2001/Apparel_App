import 'dart:io';
import 'dart:ui';
import 'package:Apparel_App/screens/auth/sign_in_screen.dart';
import 'package:Apparel_App/transitions/slide_top_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool signedIn = false;
  String? userName;
  String? displayPicture;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.uid != null) {
      signedIn = true;
      userName = currentUser?.displayName as String;
      displayPicture = currentUser?.photoURL as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Theme(
            data: Theme.of(context).copyWith(
                // Set the transparency here
                canvasColor: Colors.white.withOpacity(0.5)),
            child: Container(
              width: 240,
              child: Stack(
                children: [
                  ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: 250,
                          child: Text(" "),
                        )),
                  ),
                  Drawer(
                    child: Column(
                      // Important: Remove any padding from the ListView.
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //* Drawer header
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              30, (Platform.isAndroid) ? 35 : 50, 16, 12),
                          width: double.infinity,
                          child: (userName != null)
                              ? Row(
                                  children: [
                                    ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        height: 40,
                                        fadeInDuration:
                                            Duration(milliseconds: 100),
                                        image: displayPicture as String,
                                        placeholder:
                                            'lib/assets/dp_placeholder.jpg',
                                      ),
                                    ),
                                    // Image.asset('lib/assets/dp_placeholder.jpg'),
                                    SizedBox(width: 15),
                                    Flexible(
                                      child: Text(
                                        userName as String,
                                        style: TextStyle(
                                            fontFamily: 'sf',
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            height: 1),
                                      ),
                                    ),
                                  ],
                                )
                              : TextButton.icon(
                                  icon: Icon(
                                    Icons.login,
                                    color: Colors.black,
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                    primary: Colors.grey,
                                    backgroundColor: Colors.white,
                                  ),
                                  label: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Route route = SlideTopTransition(
                                      widget: SignInScreen(),
                                    );
                                    Navigator.push(context, route);
                                  },
                                ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 30),
                          leading: Icon(
                            Customicons.bag,
                            size: 22,
                            color: Colors.black,
                          ),
                          title: Align(
                            alignment: Alignment(-1.2, 0),
                            child: Text(
                              'My Orders',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 30),
                          leading: Icon(
                            Icons.format_list_bulleted_rounded,
                            color: Colors.black,
                          ),
                          title: Align(
                            alignment: Alignment(-1.2, 0),
                            child: Text(
                              'Wish List',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 32),
                          leading: Icon(
                            Customicons.settings,
                            size: 22,
                            color: Colors.black,
                          ),
                          title: Align(
                            alignment: Alignment(-1.2, 0),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: () {},
                        ),
                        //* Sign Out button
                        if (userName != null)
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ListTile(
                                leading: Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(
                                    30, 0, 0, (Platform.isAndroid) ? 10 : 25),
                                title: Transform.translate(
                                  offset: Offset(-15, 0),
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                onTap: () {
                                  AuthService().signOut(context);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
