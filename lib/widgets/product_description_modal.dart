import 'package:flutter/material.dart';

productDescriptionModal(context, productData) {
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
              //* Product Description Topic
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Product Description",
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              //* Product Description
              Container(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  productData.data()["description"],
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
