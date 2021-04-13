import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:Apparel_App/screens/home_screen.dart';

final AsyncMemoizer memoizer = AsyncMemoizer();
storesSection() {
  //* Get Stores
  Future getStores() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("stores").get();

    return qn.docs;
  }

  ScrollController controller;
  ScrollPhysics physics = AlwaysScrollableScrollPhysics();

  return NotificationListener<ScrollEndNotification>(
    onNotification: (scrollEnd) {
      var metrics = scrollEnd.metrics;
      if (metrics.atEdge) {
        if (metrics.pixels == 0) {
          print('At top');
          // physics = NeverScrollableScrollPhysics();
        } else
          print('At bottom');
      }
      return true;
    },
    child: SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          children: [
            Text(
              'Most popular',
              style: TextStyle(
                  fontFamily: 'sf', fontSize: 26, fontWeight: FontWeight.w700),
            ),
            //* Recent Products -----------------------------------------------------------------------------
            Container(
              child: FutureBuilder(
                future: getStores(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      //* Loading Card ----------------------------------------------------------------------
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        color: Colors.white,
                        elevation: 0,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          height: 110,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            color: Colors.white,
                            elevation: 0,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                          snapshot.data[index]
                                              .data()["cover-image"],
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
                                                      snapshot.data[index]
                                                          .data()["logo"],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              //* Store name
                                              Text(
                                                snapshot.data[index]
                                                    .data()["store-name"],
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: featureProducts(
                                          snapshot.data[index].id))
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

featureProducts(storeId) {
  print(storeId);
  //* get Featured Products
  Future getFeatureProducts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("stores")
        .doc(storeId)
        .collection("products")
        .orderBy("sold", descending: true)
        .limit(2)
        .get();

    // return memoizer.runOnce(() async {
    print(qn.docs[0]["product-name"]);
    return qn.docs;
    // });
  }

  //* Recent Products -----------------------------------------------------------------------------
  return Container(
    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: FutureBuilder(
      future: getFeatureProducts(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            //* Loading Card ----------------------------------------------------------------------
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              color: Color(0xffF3F3F3),
              elevation: 0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20, bottom: 20),
                height: 110,
              ),
            ),
          );
        } else {
          return Row(
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
                                snapshot.data[0].data()["images"][0],
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 6),
                            //* Product name
                            Text(
                              snapshot.data[0].data()["product-name"],
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
                                      .format(snapshot.data[0].data()["price"])
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
                              snapshot.data[0].data()["sold"].toString() +
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
                                snapshot.data[1].data()["images"][0],
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 6),
                            //* Product name
                            Text(
                              snapshot.data[1].data()["product-name"],
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
                                      .format(snapshot.data[1].data()["price"])
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
                              snapshot.data[1].data()["sold"].toString() +
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
          );
        }
      },
    ),
  );
}
