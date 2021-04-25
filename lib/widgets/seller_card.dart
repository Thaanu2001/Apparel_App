import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:Apparel_App/screens/home_screen.dart';

final AsyncMemoizer memoizer = AsyncMemoizer();
storeCard(storeId) {
  //* Get Stores
  Future getStoreData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("stores").get();

    return qn.docs;
  }

  CollectionReference stores = FirebaseFirestore.instance.collection('stores');

  return SingleChildScrollView(
    child: Container(
      //* Recent Products -----------------------------------------------------------------------------
      child: FutureBuilder(
        future: stores.doc(storeId).get(),
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
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 4),
              child: Card(
                //* Product Card ----------------------------------------------------------------------
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                color: Color(0xffF3F3F3),
                elevation: 0,
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
                            data["cover-image"],
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
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                        data["logo"],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                //* Store name
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["store-name"],
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "98% Positive Rating",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //* View Store Profile button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2)),
                          primary: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Text(
                          "View Store Profile",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    //* Contact Seller button -------------------------------------------------------------------
                    Container(
                      width: double.infinity,
                      // padding: EdgeInsets.only(top: 4, bottom: 4),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2)),
                          primary: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Contact Seller",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    // Container(
                    //     width: double.infinity,
                    //     child: featureProducts(storeId))
                  ],
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}

// featureProducts(storeId) {
//   print(storeId);
//   //* get Featured Products
//   Future getFeatureProducts() async {
//     var firestore = FirebaseFirestore.instance;
//     QuerySnapshot qn = await firestore
//         .collection("stores")
//         .doc(storeId)
//         .collection("products")
//         .orderBy("sold", descending: true)
//         .limit(2)
//         .get();

//     // return memoizer.runOnce(() async {
//     print(qn.docs[0]["product-name"]);
//     return qn.docs;
//     // });
//   }

//   //* Recent Products -----------------------------------------------------------------------------
//   return Container(
//     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//     child: FutureBuilder(
//       future: getFeatureProducts(),
//       builder: (_, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             width: double.infinity,
//             padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//             //* Loading Card ----------------------------------------------------------------------
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//               color: Color(0xffF3F3F3),
//               elevation: 0,
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.only(top: 20, bottom: 20),
//                 height: 110,
//               ),
//             ),
//           );
//         } else {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(
//                 fit: FlexFit.tight,
//                 flex: 1,
//                 child: Container(
//                   // width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
//                   //* Product Card 1 ---------------------------------------------------------------------
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     color: Color(0xffF3F3F3),
//                     elevation: 0,
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             //* Product Image
//                             Container(
//                               child: Image.network(
//                                 snapshot.data[0].data()["images"][0],
//                                 width: double.infinity,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             SizedBox(height: 6),
//                             //* Product name
//                             Text(
//                               snapshot.data[0].data()["product-name"],
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 14,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(height: 4),
//                             //* Product price
//                             Text(
//                               "Rs. " +
//                                   NumberFormat('###,000')
//                                       .format(snapshot.data[0].data()["price"])
//                                       .toString(),
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 14,
//                                   color: Color(0xff808080),
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: 2),
//                             //* Product sold quantity
//                             Text(
//                               snapshot.data[0].data()["sold"].toString() +
//                                   " Sold",
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 12,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w300),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onTap: () {},
//                     ),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 fit: FlexFit.tight,
//                 flex: 1,
//                 child: Container(
//                   // width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
//                   //* Product Card 2 ---------------------------------------------------------------------
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     color: Color(0xffF3F3F3),
//                     elevation: 0,
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             //* Product Image
//                             Container(
//                               child: Image.network(
//                                 snapshot.data[1].data()["images"][0],
//                                 width: double.infinity,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             SizedBox(height: 6),
//                             //* Product name
//                             Text(
//                               snapshot.data[1].data()["product-name"],
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 14,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(height: 4),
//                             //* Product price
//                             Text(
//                               "Rs. " +
//                                   NumberFormat('###,000')
//                                       .format(snapshot.data[1].data()["price"])
//                                       .toString(),
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 14,
//                                   color: Color(0xff808080),
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: 2),
//                             //* Product quantity
//                             Text(
//                               snapshot.data[1].data()["sold"].toString() +
//                                   " Sold",
//                               style: TextStyle(
//                                   fontFamily: 'sf',
//                                   fontSize: 12,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w300),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onTap: () {},
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//       },
//     ),
//   );
// }
