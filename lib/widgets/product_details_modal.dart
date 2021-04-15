import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* Name
                        Text(
                          productData.data()["product-name"],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 3),
                        //* Price
                        Text(
                          "Rs. " +
                              NumberFormat('###,000')
                                  .format((productData.data()["discount"] != 0)
                                      ? ((productData.data()["price"]) *
                                          ((100 -
                                                  productData
                                                      .data()["discount"]) /
                                              100))
                                      : productData.data()["price"])
                                  .toString(),
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w700),
                        ),
                        //* Discount old price
                        if (productData.data()["discount"] != 0)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rs. " +
                                    NumberFormat('###,000')
                                        .format(productData.data()["price"])
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 12,
                                    color: Color(0xffacacac),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "-" +
                                    productData.data()["discount"].toString() +
                                    "%",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 10,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                      ],
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
                        //* Brand Topic
                        Text(
                          "Type",
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
                        //* Clothing Style Topic
                        Text(
                          "Clothing Style",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w500),
                        ),
                        //* Pattern Topic
                        Text(
                          "Pattern",
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w500),
                        ),
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
                        //* Type
                        Text(
                          productData.data()["product-details"]["type"],
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
                        //* Clothing Style
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
                        //* Pattern
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
