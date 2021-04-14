import 'package:Apparel_App/sections/men_section.dart';
import 'package:Apparel_App/sections/stores_section.dart';
import 'package:Apparel_App/sections/women_section.dart';
import 'package:flutter/material.dart';
import 'package:Apparel_App/services/Customicons_icons.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'dart:ui' show ImageFilter;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  Future getWomenProducts() async {
    //* Get vehicle documents
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("products")
        .doc("women")
        .collection("women")
        .orderBy("upload-time", descending: true)
        .get();

    return qn.docs;
  }

  // @override
  // void initState() {
  //   //* Flutter pull to refresh
  //   _anicontroller = AnimationController(
  //       vsync: this, duration: Duration(milliseconds: 2000));
  //   _scaleController =
  //       AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
  //   _refreshController.headerMode.addListener(() {
  //     if (_refreshController.headerStatus == RefreshStatus.idle) {
  //       _scaleController.value = 0.0;
  //       _anicontroller.reset();
  //     } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
  //       _anicontroller.repeat();
  //     }
  //   });
  //   super.initState();
  // }

  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   setState(() {});
  //   _refreshController.refreshCompleted();
  // }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // items.add((items.length+1).toString());
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      drawerScrimColor: Colors.transparent,
      //* Floating shopping cart button ---------------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Customicons.shopping_cart, size: 28),
        backgroundColor: Color(0xff646464),
        elevation: 4,
      ),
      //* Side drawer ---------------------------------------------------------------------------------------------
      drawer: Theme(
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white.withOpacity(0.5)),
        child: Container(
            width: 240,
            child: Stack(children: [
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
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
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
                //* Pull to refresh
                // child: SmartRefresher(
                //   physics: AlwaysScrollableScrollPhysics(),
                //   enablePullDown: true,
                //   controller: _refreshController,
                //   onRefresh: _onRefresh,
                //   onLoading: _onLoading,
                //   child: ListView(
                //       shrinkWrap: true,
                //       physics: ClampingScrollPhysics(),
                //       children: [
                // height: 2000,
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
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      //* Tab Content
                      child: Container(
                        height: 500,
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            womenSection(context), //* Womens Section
                            menSection(), //* Mens Section
                            Container(
                              child: Center(
                                child: Text('Display Tab 4',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            storesSection(), //* Stores Section
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            // header: CustomHeader(
            //   //* Pull to refresh header --------------------------------------------------------------------
            //   refreshStyle: RefreshStyle.Behind,
            //   onOffsetChange: (offset) {
            //     if (_refreshController.headerMode.value !=
            //         RefreshStatus.refreshing)
            //       _scaleController.value = offset / 80.0;
            //   },
            //   builder: (c, m) {
            //     return Container(
            //       child: FadeTransition(
            //         opacity: _scaleController,
            //         child: ScaleTransition(
            //           child: SpinKitFadingCircle(
            //             size: 30.0,
            //             // color: Color(0xffA4A4A4),
            //             // animationController: _anicontroller,
            //             itemBuilder: (_, int index) {
            //               return DecoratedBox(
            //                 decoration: BoxDecoration(
            //                     color: Color(0xffA4A4A4),
            //                     borderRadius: BorderRadius.circular(50)),
            //               );
            //             },
            //           ),
            //           scale: _scaleController,
            //         ),
            //       ),
            //       alignment: Alignment.center,
            //     );
            //   },
            // ),
            //),
          ),
        ],
      ),
    );
  }
}
