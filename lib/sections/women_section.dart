import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:Apparel_App/screens/home_screen.dart';
import 'package:Apparel_App/screens/product_details_screen.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';

class WomenSection extends StatefulWidget {
  @override
  _WomenSectionState createState() => _WomenSectionState();
}

class _WomenSectionState extends State<WomenSection>
    with TickerProviderStateMixin {
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _data = <DocumentSnapshot>[];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late AnimationController _anicontroller, _scaleController;
  bool keepAlive = false;

  //* Pull to refresh on refresh
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      _data.clear();
      _lastVisible = null;
      _getWomenProducts();
    });
    _refreshController.refreshCompleted();
  }

  //* Pull to refresh on loading
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  //* Get Women Product documents
  Future<Null> _getWomenProducts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn;

    if (_lastVisible == null) {
      qn = await firestore
          .collection("products")
          .doc("women")
          .collection("women")
          .orderBy("upload-time", descending: true)
          .limit(5)
          .get();
    } else {
      qn = await firestore
          .collection("products")
          .doc("women")
          .collection("women")
          .orderBy("upload-time", descending: true)
          .startAfter([_lastVisible!["upload-time"]])
          .limit(5)
          .get();
    }

    if (qn != null && qn.docs.length > 0) {
      _lastVisible = qn.docs[qn.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(qn.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('No more products!'),
          backgroundColor: Color(0xff646464),
        ),
      );
    }
    return null;
  }

  @override
  void initState() {
    //* Flutter pull to refresh
    _anicontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _refreshController.headerMode!.addListener(() {
      if (_refreshController.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _anicontroller.reset();
      } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
        _anicontroller.repeat();
      }
    });

    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();

    _isLoading = true;
    _getWomenProducts();
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    _refreshController.dispose();
    _scaleController.dispose();
    _anicontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        controller: controller,
        children: [
          Text(
            'Recent',
            style: TextStyle(
                fontFamily: 'sf', fontSize: 26, fontWeight: FontWeight.w700),
          ),
          //* Recent Products -----------------------------------------------------------------------------
          Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _data.length + 1,
              itemBuilder: (_, int index) {
                if (index < _data.length) {
                  final DocumentSnapshot document = _data[index];
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    //* Main Card shadow
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      // the box shawdow property allows for fine tuning as aposed to shadowColor
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black26,
                          // offset, the X,Y coordinates to offset the shadow
                          offset: new Offset(5.0, 5.0),
                          // blurRadius, the higher the number the more smeared look
                          blurRadius: 36.0,
                          spreadRadius: -23,
                        )
                      ],
                    ),
                    //* Product Card ----------------------------------------------------------------------
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  //* Product Image
                                  child: Hero(
                                placeholderBuilder: (context, heroSize, child) {
                                  return Opacity(opacity: 1, child: child);
                                },
                                transitionOnUserGestures: true,
                                tag: document.id,
                                child: Image.network(
                                  document["images"][0],
                                  // width: 90,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              )),
                              SizedBox(width: 15),
                              Flexible(
                                //* Product details
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      document["product-name"],
                                      style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      document["store-name"],
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          "Rs. " +
                                              NumberFormat('###,000')
                                                  .format((document[
                                                              "discount"] !=
                                                          0)
                                                      ? ((document["price"]) *
                                                          ((100 -
                                                                  document[
                                                                      "discount"]) /
                                                              100))
                                                      : document["price"])
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 16,
                                              color: Color(0xff808080),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(width: 5),
                                        if (document["discount"] != 0)
                                          Text(
                                            "Rs. " +
                                                NumberFormat('###,000')
                                                    .format(document["price"])
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: 'sf',
                                                fontSize: 12,
                                                color: Color(0xaa808080),
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      document["sold"].toString() + " Sold",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //* Navigate to product details screen ----------------------------------------------------------------------------
                        onTap: () {
                          Route route = SlideLeftTransition(
                            widget: ProductDetailsScreen(
                                productData: document, category: "women"),
                          );
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                  );
                }
                return Center(
                  child: new Opacity(
                    opacity: _isLoading ? 1.0 : 0.0,
                    child: new SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: new CupertinoActivityIndicator(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      //* Pull to refresh header --------------------------------------------------------------------
      header: CustomHeader(
        refreshStyle: RefreshStyle.Behind,
        onOffsetChange: (offset) {
          if (_refreshController.headerMode!.value != RefreshStatus.refreshing)
            _scaleController.value = offset / 80.0;
        },
        height: 20,
        builder: (c, m) {
          return Container(
            child: FadeTransition(
              opacity: _scaleController,
              child: ScaleTransition(
                child: CupertinoActivityIndicator(),
                scale: _scaleController,
              ),
            ),
            alignment: Alignment.center,
          );
        },
      ),
    );
  }

  //* Scroll Listener
  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getWomenProducts();
      }
    }
  }
}
