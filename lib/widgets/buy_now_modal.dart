import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

buyNowModal(context, productData) {
  GlobalKey<FormFieldState> _key = GlobalKey();
  String selectedSize;
  int _quantity = 0;
  String errorMsg;
  bool errorVisible = false;

  //* Get available sizes
  List<String> sizeList = [];
  print(productData.data()["size"].length);
  for (int count = 0; count < productData.data()["size"].length; count++) {
    if (productData.data()["size"]
            [productData.data()["size"].keys.elementAt(count)] !=
        0) {
      sizeList.add(productData.data()["size"].keys.elementAt(count));
    } else {
      sizeList.add(
          productData.data()["size"].keys.elementAt(count) + " (Sold out)");
    }
  }
  print(sizeList);

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                    //* Product Image
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
                                    .format((productData.data()["discount"] !=
                                            0)
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
                                      productData
                                          .data()["discount"]
                                          .toString() +
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
                //* Select size section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 8,
                      child: Container(
                        //* Select Size Dropdown ----------------------------------------------------------------------
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 12, top: 0, bottom: 0, right: 8),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'sf',
                              fontSize: 16,
                            ),
                            filled: true,
                            labelText: 'Select Size',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  new BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          focusColor: Colors.black,
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.black,
                          items: sizeList.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              onTap: () => null,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 16,
                                    color: (!value.contains('(Sold out)'))
                                        ? Colors.black
                                        : Color(0xffacacac),
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          value: selectedSize,
                          key: _key,
                          onChanged: (value) {
                            if ((!value.contains('(Sold out)'))) {
                              setState(() {
                                selectedSize = value;
                                errorVisible = false;
                                _quantity = 1;
                              });
                            } else {
                              setState(() {
                                selectedSize = null;
                                _key.currentState.reset();
                                _quantity = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    //* Show Chart button
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Container(
                        // height: double.infinity,
                        margin: EdgeInsets.fromLTRB(8, 15, 0, 0),
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: Icon(Customicons.measuring_tape,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                // //* Product Description Section ------------------------------------------------------
                // Container(
                //   padding: EdgeInsets.only(top: 8),
                //   child: InkWell(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         //* Product Description Topic
                //         // Icon(Icons.shirt)
                //         Text(
                //           "View size chart",
                //           style: TextStyle(
                //               fontFamily: 'sf',
                //               fontSize: 16,
                //               color: Colors.black,
                //               fontWeight: FontWeight.w400),
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 10),
                //           child: Icon(
                //             Icons.arrow_forward_ios_rounded,
                //             color: Color(0xffc5c5c5),
                //             size: 15,
                //           ),
                //         ),
                //       ],
                //     ),
                //     onTap: () {},
                //   ),
                // )
                //* Quantity Section
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 4),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //* Minus Button
                      InkWell(
                        child: Icon(Icons.remove, size: 30),
                        onTap: () {
                          if (selectedSize == null) {
                            setState(() {
                              errorVisible = true;
                              errorMsg = 'Please select size first';
                            });
                          }
                          if (_quantity > 0) {
                            setState(() {
                              errorVisible = false;
                              _quantity--;
                            });
                          }
                        },
                      ),
                      //* Quantity
                      Text(
                        (_quantity == 0) ? 'Quantity' : _quantity.toString(),
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      //* Add button
                      InkWell(
                        child: Icon(Icons.add, size: 30),
                        onTap: () {
                          if (selectedSize == null) {
                            setState(() {
                              errorVisible = true;
                              errorMsg = 'Please select size first';
                            });
                          } else if (_quantity <
                              productData.data()["size"][selectedSize]) {
                            setState(() {
                              errorVisible = false;
                              _quantity++;
                            });
                            if (_quantity ==
                                productData.data()["size"][selectedSize]) {
                              setState(() {
                                errorVisible = true;
                                errorMsg = 'Maximum quantity reached';
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                //* Quantity error message
                if (errorVisible)
                  Text(
                    errorMsg,
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        );
      });
    },
  );
}
