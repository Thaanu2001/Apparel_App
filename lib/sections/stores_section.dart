import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:Apparel_App/screens/home_screen.dart';

class StoresSection extends StatefulWidget {
  @override
  _StoresSectionState createState() => _StoresSectionState();
}

class _StoresSectionState extends State<StoresSection>
    with TickerProviderStateMixin {
  int storeProductsCount = 0;
  bool _isLoading;
  bool keepAlive = false;
  List _storeIDList = [];

  List<DocumentSnapshot> _storeData = <DocumentSnapshot>[];
  List<DocumentSnapshot> _storeProducts = <DocumentSnapshot>[];
  DocumentSnapshot _lastVisible;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  AnimationController _anicontroller, _scaleController;
  ScrollController controller;

  //* Pull to refresh on refresh
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      _storeData.clear();
      _lastVisible = null;
      _getStores();
      // _getStoreProducts();
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
  Future<Null> _getStores() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn;

    if (_lastVisible == null) {
      qn = await firestore
          .collection("stores")
          .orderBy("sales", descending: true)
          .limit(2)
          .get();
    } else {
      qn = await firestore
          .collection("stores")
          .orderBy("sales", descending: true)
          .startAfter([_lastVisible["sales"]])
          .limit(2)
          .get();
    }

    if (qn != null && qn.docs.length > 0) {
      _lastVisible = qn.docs[qn.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _storeData.addAll(qn.docs);
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

  //* Get peoducts from each store
  Future<Null> _getStoreProducts(storeId) async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn;

    qn = await firestore
        .collection("stores")
        .doc(storeId)
        .collection("products")
        .orderBy("sold", descending: true)
        .limit(2)
        .get();

    if (!_storeIDList.contains(storeId)) {
      _storeProducts.addAll(qn.docs);
      _storeIDList.add(storeId);
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
    _refreshController.headerMode.addListener(() {
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
    _getStores();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
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
            'Most Popular',
            style: TextStyle(
                fontFamily: 'sf', fontSize: 26, fontWeight: FontWeight.w700),
          ),
          //* Recent Products -----------------------------------------------------------------------------
          Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _storeData.length + 1,
              itemBuilder: (_, int index) {
                if (index < _storeData.length) {
                  final DocumentSnapshot document = _storeData[index];
                  return Container(
                    width: double.infinity,
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
                    margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Card(
                      //* Product Card ----------------------------------------------------------------------
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              //* Store cover stack --------------------------------------------------------
                              child: Stack(
                                children: [
                                  //* Cover Image
                                  Image.network(
                                    document["cover-image"],
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  //* Cover Gradient
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black12,
                                          // Colors.transparent,
                                          Colors.black87,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    height: 120,
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        //* Store logo
                                        new Container(
                                          width: 50,
                                          height: 50,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                document["logo"],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        //* Store name
                                        Text(
                                          document["store-name"],
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                child: featureProducts(document.id, index))
                          ],
                        ),
                        onTap: () {},
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
                        child: new CupertinoActivityIndicator()),
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
          if (_refreshController.headerMode.value != RefreshStatus.refreshing)
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
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getStores();
      }
    }
  }

  //* Store feature products
  featureProducts(storeId, index) {
    print(storeId);
    print(_storeProducts.length.toString());

    _getStoreProducts(storeId);

    //* Recent Products -----------------------------------------------------------------------------
    return (_storeProducts.length != 0)
        ? Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    // width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                    //* Product Card 1 ---------------------------------------------------------------------
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      color: Color(0xffF3F3F3),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* Product Image
                              Container(
                                child: Image.network(
                                  _storeProducts[index * 2]["images"][0],
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 6),
                              //* Product name
                              Text(
                                _storeProducts[index * 2]["product-name"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              //* Product price
                              Text(
                                "Rs. " +
                                    NumberFormat('###,000')
                                        .format(
                                            _storeProducts[index * 2]["price"])
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 14,
                                    color: Color(0xff808080),
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 2),
                              //* Product sold quantity
                              Text(
                                _storeProducts[index * 2]["sold"].toString() +
                                    " Sold",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    // width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                    //* Product Card 2 ---------------------------------------------------------------------
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      color: Color(0xffF3F3F3),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* Product Image
                              Container(
                                child: Image.network(
                                  _storeProducts[(index * 2) + 1]["images"][0],
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 6),
                              //* Product name
                              Text(
                                _storeProducts[(index * 2) + 1]["product-name"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              //* Product price
                              Text(
                                "Rs. " +
                                    NumberFormat('###,000')
                                        .format(_storeProducts[(index * 2) + 1]
                                            ["price"])
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 14,
                                    color: Color(0xff808080),
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 2),
                              //* Product quantity
                              Text(
                                _storeProducts[(index * 2) + 1]["sold"]
                                        .toString() +
                                    " Sold",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
