import 'dart:io';
import 'dart:ui';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    height: 100,
                    width: double.infinity,
                    //* Drawer header
                    child: DrawerHeader(
                      child: Text(
                        'Gadget Doctor',
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
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
  }
}
