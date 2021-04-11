import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WomenSection extends StatefulWidget {
  @override
  _WomenSectionState createState() => _WomenSectionState();
}

class _WomenSectionState extends State<WomenSection> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent',
            style: TextStyle(
                fontFamily: 'sf', fontSize: 26, fontWeight: FontWeight.w700),
          ),
          Container(
            //* Recent Products -----------------------------------------------------------------------------
            child: FutureBuilder(
              future: getWomenProducts(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Card(
                      //* Loading Card ----------------------------------------------------------------------
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
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Card(
                          //* Product Card ----------------------------------------------------------------------
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
                                    child: Image.network(
                                      snapshot.data[index].data()["images"][0],
                                      // width: 90,
                                      height: 110,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Flexible(
                                    //* Product details
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          snapshot.data[index]
                                              .data()["product-name"],
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          snapshot.data[index]
                                              .data()["store-name"],
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "Rs. " +
                                              NumberFormat('###,000')
                                                  .format(snapshot.data[index]
                                                      .data()["price"])
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 16,
                                              color: Color(0xff808080),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          snapshot.data[index]
                                                  .data()["sold"]
                                                  .toString() +
                                              " Sold",
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
    );
  }
}
