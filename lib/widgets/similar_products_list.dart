import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

similarProductsList({context, category, color, clothingStyle, productId}) {
  //* Get Similar Product documents
  Future getSimilarProducts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("products")
        .doc(category)
        .collection(category)
        .where("product-details.clothing-style", isEqualTo: clothingStyle)
        .where("product-details.color", isEqualTo: color)
        .limit(8)
        // .orderBy("upload-time", descending: true)
        .get();

    return qn.docs;
  }

  //* Similar Products -----------------------------------------------------------------------------
  return Container(
    height: 234,
    child: FutureBuilder(
      future: getSimilarProducts(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
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
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              if (productId != snapshot.data[index].id)
                return Container(
                  height: 300,
                  // width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 5, 12, 5),
                  //* Product Card ----------------------------------------------------------------------
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: Color(0xffF3F3F3),
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Product Image
                            Container(
                              child: Image.network(
                                snapshot.data[index].data()["images"][0],
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 6),
                            //* Product name
                            Text(
                              snapshot.data[index].data()["product-name"],
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
                                      .format((snapshot.data[index]
                                                  .data()["discount"] !=
                                              0)
                                          ? ((snapshot.data[index]
                                                  .data()["price"]) *
                                              ((100 -
                                                      snapshot.data[index]
                                                          .data()["discount"]) /
                                                  100))
                                          : snapshot.data[index]
                                              .data()["price"])
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
                              snapshot.data[index].data()["store-name"],
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
                );
            },
          );
        }
      },
    ),
  );
}
