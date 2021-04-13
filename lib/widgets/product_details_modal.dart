import 'package:flutter/material.dart';

productDetailsModal(context, productData) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Wrap(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    productData.data()["images"][0],
                    height: 100,
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        productData.data()["product-name"],
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              //* Product Details Topic
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Product Details",
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              // SizedBox(height: 4),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (productData
                            .data()["product-details"]["brand"]
                            .contains("brand"))
                          //* Brand Topic
                          Text(
                            "Brand",
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500),
                          ),
                        //* Color Topic
                        Text(
                          "Colour",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w500),
                        ),
                        //* Material Topic
                        Text(
                          "Material",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w500),
                        ),
                        //* Clothing Style Topic
                        if (productData
                            .data()["product-details"]
                            .containsKey("clothing-style"))
                          Text(
                            "Clothing Style",
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500),
                          ),
                        //* Sleeves Topic
                        if (productData
                            .data()["product-details"]
                            .containsKey("sleeves"))
                          Text(
                            "Sleeves",
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500),
                          ),
                        //* Collar Type Topic
                        if (productData
                            .data()["product-details"]
                            .containsKey("collar-type"))
                          Text(
                            "Collar Type",
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500),
                          ),
                        //* Pattern Topic
                        if (productData
                            .data()["product-details"]
                            .containsKey("pattern"))
                          Text(
                            "Pattern",
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500),
                          ),
                        // Container(
                        //   height: 300,
                        // )
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* Brand
                        Text(
                          productData.data()["product-details"]["brand"],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        //* Color
                        Text(
                          productData.data()["product-details"]["color"],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        //* Material
                        Text(
                          productData.data()["product-details"]["material"],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        //* Clothing Style
                        if (productData
                            .data()["product-details"]
                            .containsKey("clothing-style"))
                          Text(
                            productData.data()["product-details"]
                                ["clothing-style"],
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        //* Sleeves
                        if (productData
                            .data()["product-details"]
                            .containsKey("sleeves"))
                          Text(
                            productData.data()["product-details"]["sleeves"],
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        //* Collar Type
                        if (productData
                            .data()["product-details"]
                            .containsKey("collar-type"))
                          Text(
                            productData.data()["product-details"]
                                ["collar-type"],
                            style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 14,
                                height: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        //* Pattern
                        if (productData
                            .data()["product-details"]
                            .containsKey("pattern"))
                          Text(
                            productData.data()["product-details"]["pattern"],
                            style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
