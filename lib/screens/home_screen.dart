import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

import 'package:Apparel_App/sections/men_section.dart';
import 'package:Apparel_App/sections/stores_section.dart';
import 'package:Apparel_App/sections/women_section.dart';
import 'package:Apparel_App/services/Customicons_icons.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/widgets/shopping_cart_button.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      drawerScrimColor: Colors.transparent,
      //* Floating shopping cart button ---------------------------------------------------------------------------
      floatingActionButton: ShoppingCartButton(),
      //* Side drawer ---------------------------------------------------------------------------------------------
      drawer: Theme(
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
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 5),
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
      ),
      backgroundColor: Color(0xffF3F3F3),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //* Side menu icon ---------------------------------------------------------------------------
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    child: Icon(
                      Icons.menu_rounded,
                      size: 32,
                      color: Color(0xff646464),
                    ),
                    onTap: () => scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                //* Search bar --------------------------------------------------------------------------------
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 40,
                    // color: Colors.red,
                    child: TextField(
                      cursorColor: Color(0xff646464),
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Color(0xff646464),
                          fontWeight: FontWeight.w500),
                      decoration: new InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        suffixIcon: Icon(
                          Icons.search,
                          size: 28,
                          color: Color(0xff646464),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.red,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Flexible(
            child: ScrollGlowDisabler(
                //* Top Tab Bar ------------------------------------------------------------------------------
                child: DefaultTabController(
              length: 4, // length of tabs
              initialIndex: 0,
              child: Container(
                height: 1000,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      //* Tab bar customize
                      child: TabBar(
                        isScrollable: false,
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.black,
                        unselectedLabelColor: Color(0xffA4A4A4),
                        labelStyle: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        unselectedLabelStyle: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        tabs: [
                          Tab(text: 'Women'),
                          Tab(text: 'Men'),
                          Tab(text: 'Kids'),
                          Tab(text: 'Stores'),
                        ],
                        onTap: (index) {
                          setState(() {
                            _tabIndex = index;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      //* Tab Content
                      child: Container(
                        height: 500,
                        child: IndexedStack(
                          index: _tabIndex,
                          children: <Widget>[
                            WomenSection(), //* Women Section
                            MenSection(), //* Men Section
                            Container(
                              child: Center(
                                child: Text('Display Tab 4',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            StoresSection(), //* Stores Section
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
