import 'package:Apparel_App/services/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShoppingCartList extends StatefulWidget {
  @override
  _ShoppingCartListState createState() => _ShoppingCartListState();
}

class _ShoppingCartListState extends State<ShoppingCartList> {
  Map cartItemsList;

  @override
  void initState() {
    print('awa');
    cartItemsList = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CartItems().getCartItemsList(),
      builder: (_, snapshot) {
        if (cartItemsList == null) cartItemsList = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          return Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartItemsList.length,
              itemBuilder: (_, int index) {
                int _quantity = cartItemsList.values.elementAt(index)[8];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Store name
                    if (index == 0 ||
                        cartItemsList.values.elementAt(index)[6].toString() !=
                            cartItemsList.values
                                .elementAt(index - 1)[6]
                                .toString())
                      Container(
                        padding: EdgeInsets.only(top: 7),
                        child: Text(
                          cartItemsList.values.elementAt(index)[6].toString(),
                          style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    // SizedBox(height: 8),
                    Container(
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
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //* Product Image
                                child: Image.network(
                                  cartItemsList.values
                                      .elementAt(index)[2]
                                      .toString(),
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                //* Product details
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //* Product name
                                    Text(
                                      cartItemsList.values
                                          .elementAt(index)[1]
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //* Quantity Section
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //* Product size
                                                  Text(
                                                    cartItemsList.values
                                                        .elementAt(index)[9]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'sf',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff808080),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Container(
                                                    width: 55,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        //* Minus Button
                                                        InkWell(
                                                          child: Icon(
                                                              Icons
                                                                  .remove_circle_outline_rounded,
                                                              size: 17),
                                                          onTap: () {
                                                            if (_quantity > 1) {
                                                              setState(() {
                                                                _quantity--;
                                                              });
                                                              cartItemsList
                                                                      .values
                                                                      .elementAt(
                                                                          index)[
                                                                  8] -= 1;
                                                              CartItems().updateCart(
                                                                  itemDataMap:
                                                                      cartItemsList,
                                                                  quantityDiff:
                                                                      -1);
                                                            }
                                                          },
                                                        ),
                                                        //* Quantity
                                                        Text(
                                                          _quantity.toString(),
                                                          style: TextStyle(
                                                              fontFamily: 'sf',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        //* Add button
                                                        InkWell(
                                                          child: Icon(
                                                              Icons
                                                                  .add_circle_outline_rounded,
                                                              size: 17),
                                                          onTap: () {
                                                            if (_quantity <
                                                                int.parse(cartItemsList
                                                                    .values
                                                                    .elementAt(
                                                                        index)[10]
                                                                    .toString())) {
                                                              setState(() {
                                                                _quantity++;
                                                              });
                                                              cartItemsList
                                                                      .values
                                                                      .elementAt(
                                                                          index)[
                                                                  8] += 1;
                                                              CartItems().updateCart(
                                                                  itemDataMap:
                                                                      cartItemsList,
                                                                  quantityDiff:
                                                                      1);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  //* Discounted price
                                                  Text(
                                                    "Rs. " +
                                                        NumberFormat('###,000')
                                                            .format((int.parse(cartItemsList
                                                                        .values
                                                                        .elementAt(index)[
                                                                            4]
                                                                        .toString()) !=
                                                                    0)
                                                                ? ((int.parse(cartItemsList.values.elementAt(index)[3].toString())) *
                                                                        ((100 - int.parse(cartItemsList.values.elementAt(index)[4].toString())) /
                                                                            100)) *
                                                                    _quantity
                                                                : int.parse(cartItemsList
                                                                    .values
                                                                    .elementAt(
                                                                        index)[3]
                                                                    .toString()))
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'sf',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff808080),
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  //* Real price
                                                  if (int.parse(snapshot
                                                          .data.values
                                                          .elementAt(index)[4]
                                                          .toString()) !=
                                                      0)
                                                    Text(
                                                      "Rs. " +
                                                          NumberFormat(
                                                                  '###,000')
                                                              .format(int.parse(cartItemsList
                                                                      .values
                                                                      .elementAt(
                                                                          index)[3]
                                                                      .toString()) *
                                                                  _quantity)
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily: 'sf',
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xaa808080),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  //* Shipping price
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                      (index == 0 ||
                                                              cartItemsList
                                                                      .values
                                                                      .elementAt(index)[
                                                                          6]
                                                                      .toString() !=
                                                                  cartItemsList
                                                                      .values
                                                                      .elementAt(
                                                                          index -
                                                                              1)[
                                                                          6]
                                                                      .toString())
                                                          ? '+ ' +
                                                              cartItemsList
                                                                  .values
                                                                  .elementAt(
                                                                      index)[5]
                                                                  .toString()
                                                          : 'Free shipping',
                                                      style: TextStyle(
                                                          fontFamily: 'sf',
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff505050),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 3),
                                    //* Product remove button
                                    InkWell(
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          cartItemsList.remove(cartItemsList
                                              .keys
                                              .elementAt(index));
                                        });
                                        CartItems().updateCart(
                                            itemDataMap: cartItemsList,
                                            quantity: _quantity);
                                        print(
                                            'items' + cartItemsList.toString());
                                        if (cartItemsList.isEmpty)
                                          Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
