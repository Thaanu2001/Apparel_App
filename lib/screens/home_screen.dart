import 'package:Apparel_App/screens/product_details_screen.dart';
import 'package:Apparel_App/sections/men_section.dart';
import 'package:Apparel_App/sections/stores_section.dart';
import 'package:Apparel_App/sections/women_section.dart';
import 'package:Apparel_App/transitions/sliding_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Apparel_App/services/Customicons_icons.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'dart:ui' show ImageFilter;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  // ScrollController controller;
  // DocumentSnapshot _lastVisible;
  // bool _isLoading;
  // List<DocumentSnapshot> _data = new List<DocumentSnapshot>();
  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);
  // AnimationController _anicontroller, _scaleController;

  // //* Pull to refresh on refresh
  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   setState(() {
  //     _data.clear();
  //     _lastVisible = null;
  //     _getWomenProducts();
  //   });
  //   _refreshController.refreshCompleted();
  // }

  // //* Pull to refresh on loading
  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // items.add((items.length+1).toString());
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

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

  //   controller = new ScrollController()..addListener(_scrollListener);
  //   super.initState();

  //   _isLoading = true;
  //   _getWomenProducts();
  // }

  // @override
  // void dispose() {
  //   controller.removeListener(_scrollListener);
  //   _refreshController.dispose();
  //   _scaleController.dispose();
  //   _anicontroller.dispose();
  //   super.dispose();
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
                            storesSection(), //* Stores Section
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

  // //* Get Women Product documents
  // Future<Null> _getWomenProducts() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot qn;

  //   if (_lastVisible == null) {
  //     qn = await firestore
  //         .collection("products")
  //         .doc("women")
  //         .collection("women")
  //         .orderBy("upload-time", descending: true)
  //         .limit(4)
  //         .get();
  //   } else {
  //     qn = await firestore
  //         .collection("products")
  //         .doc("women")
  //         .collection("women")
  //         .orderBy("upload-time", descending: true)
  //         .startAfter([_lastVisible["upload-time"]])
  //         .limit(4)
  //         .get();
  //   }

  //   if (qn != null && qn.docs.length > 0) {
  //     _lastVisible = qn.docs[qn.docs.length - 1];
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //         _data.addAll(qn.docs);
  //       });
  //     }
  //   } else {
  //     setState(() => _isLoading = false);
  //     scaffoldKey.currentState?.showSnackBar(
  //       SnackBar(
  //         content: Text('No more products!'),
  //       ),
  //     );
  //   }
  //   return null;
  // }

  // womenSection(context) {
  //   //* Pull to refresh
  //   return SmartRefresher(
  //     enablePullDown: true,
  //     controller: _refreshController,
  //     onRefresh: _onRefresh,
  //     onLoading: _onLoading,
  //     child: ListView(
  //       padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
  //       controller: controller,
  //       children: [
  //         Text(
  //           'Recent',
  //           style: TextStyle(
  //               fontFamily: 'sf', fontSize: 26, fontWeight: FontWeight.w700),
  //         ),
  //         //* Recent Products -----------------------------------------------------------------------------
  //         Container(
  //           child: ListView.builder(
  //             padding: EdgeInsets.zero,
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemCount: _data.length + 1,
  //             itemBuilder: (_, int index) {
  //               if (index < _data.length) {
  //                 final DocumentSnapshot document = _data[index];
  //                 return Container(
  //                   width: double.infinity,
  //                   margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //                   //* Main Card shadow
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     // the box shawdow property allows for fine tuning as aposed to shadowColor
  //                     boxShadow: [
  //                       new BoxShadow(
  //                         color: Colors.black26,
  //                         // offset, the X,Y coordinates to offset the shadow
  //                         offset: new Offset(5.0, 5.0),
  //                         // blurRadius, the higher the number the more smeared look
  //                         blurRadius: 36.0,
  //                         spreadRadius: -23,
  //                       )
  //                     ],
  //                   ),
  //                   //* Product Card ----------------------------------------------------------------------
  //                   child: Card(
  //                     margin: EdgeInsets.zero,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     ),
  //                     color: Colors.white,
  //                     elevation: 0,
  //                     child: InkWell(
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                       child: Container(
  //                         padding: EdgeInsets.all(15),
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                                 //* Product Image
  //                                 child: Hero(
  //                               placeholderBuilder: (context, heroSize, child) {
  //                                 return Opacity(opacity: 1, child: child);
  //                               },
  //                               transitionOnUserGestures: true,
  //                               tag: document.id,
  //                               child: Image.network(
  //                                 document["images"][0],
  //                                 // width: 90,
  //                                 height: 110,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             )),
  //                             SizedBox(width: 15),
  //                             Flexible(
  //                               //* Product details
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   SizedBox(height: 5),
  //                                   Text(
  //                                     document["product-name"],
  //                                     style: TextStyle(
  //                                         fontFamily: 'sf',
  //                                         fontSize: 16,
  //                                         color: Colors.black),
  //                                   ),
  //                                   SizedBox(height: 2),
  //                                   Text(
  //                                     document["store-name"],
  //                                     style: TextStyle(
  //                                         fontFamily: 'sf',
  //                                         fontSize: 14,
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.w300),
  //                                   ),
  //                                   SizedBox(height: 6),
  //                                   Row(
  //                                     children: [
  //                                       Text(
  //                                         "Rs. " +
  //                                             NumberFormat('###,000')
  //                                                 .format((document[
  //                                                             "discount"] !=
  //                                                         0)
  //                                                     ? ((document["price"]) *
  //                                                         ((100 -
  //                                                                 document[
  //                                                                     "discount"]) /
  //                                                             100))
  //                                                     : document["price"])
  //                                                 .toString(),
  //                                         style: TextStyle(
  //                                             fontFamily: 'sf',
  //                                             fontSize: 16,
  //                                             color: Color(0xff808080),
  //                                             fontWeight: FontWeight.w700),
  //                                       ),
  //                                       SizedBox(width: 5),
  //                                       if (document["discount"] != 0)
  //                                         Text(
  //                                           "Rs. " +
  //                                               NumberFormat('###,000')
  //                                                   .format(document["price"])
  //                                                   .toString(),
  //                                           style: TextStyle(
  //                                               fontFamily: 'sf',
  //                                               fontSize: 12,
  //                                               color: Color(0xaa808080),
  //                                               fontWeight: FontWeight.w500,
  //                                               decoration:
  //                                                   TextDecoration.lineThrough),
  //                                         ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 2),
  //                                   Text(
  //                                     document["sold"].toString() + " Sold",
  //                                     style: TextStyle(
  //                                         fontFamily: 'sf',
  //                                         fontSize: 13,
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.w300),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       //* Navigate to product details screen ----------------------------------------------------------------------------
  //                       onTap: () {
  //                         Route route = SlidingTransition(
  //                           widget: ProductDetailsScreen(
  //                               productData: document, category: "women"),
  //                         );
  //                         Navigator.push(context, route);
  //                       },
  //                     ),
  //                   ),
  //                 );
  //               }
  //               return Center(
  //                 child: new Opacity(
  //                   opacity: _isLoading ? 1.0 : 0.0,
  //                   child: new SizedBox(
  //                       width: 32.0,
  //                       height: 32.0,
  //                       child: new CupertinoActivityIndicator()),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //     //* Pull to refresh header --------------------------------------------------------------------
  //     header: CustomHeader(
  //       refreshStyle: RefreshStyle.Behind,
  //       onOffsetChange: (offset) {
  //         if (_refreshController.headerMode.value != RefreshStatus.refreshing)
  //           _scaleController.value = offset / 80.0;
  //       },
  //       height: 20,
  //       builder: (c, m) {
  //         return Container(
  //           child: FadeTransition(
  //             opacity: _scaleController,
  //             child: ScaleTransition(
  //               child: CupertinoActivityIndicator(),
  //               scale: _scaleController,
  //             ),
  //           ),
  //           alignment: Alignment.center,
  //         );
  //       },
  //     ),
  //   );
  // }

  // //* Scroll Listener
  // void _scrollListener() {
  //   if (!_isLoading) {
  //     if (controller.position.pixels == controller.position.maxScrollExtent) {
  //       setState(() => _isLoading = true);
  //       _getWomenProducts();
  //     }
  //   }
  // }
}
