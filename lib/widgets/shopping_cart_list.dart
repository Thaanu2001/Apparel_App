import 'package:Apparel_App/screens/product_details_screen.dart';
import 'package:Apparel_App/services/cart_items.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingCartList extends StatefulWidget {
  @override
  _ShoppingCartListState createState() => _ShoppingCartListState();
}

class _ShoppingCartListState extends State<ShoppingCartList> {
  Map? _cartItemsList;
  ValueNotifier<int> _totalPriceNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> _totalDeliveryNotifier = ValueNotifier<int>(0);
  DocumentSnapshot? productData;
  int _totalPrice = 0;
  int _totalDelivery = 0;

  @override
  void initState() {
    print('awa');
    _cartItemsList = null;
    _totalPrice = 0;
    super.initState();
  }

  //* Get total price and delivery of checkout items ------------------------------------------------
  getTotal() {
    _totalPrice = 0;
    _cartItemsList!.values.forEach((item) => _totalPrice += ((item[4] != 0)
            ? (item[3] * ((100 - item[4]) / 100)) * item[8]
            : item[3] * item[8])
        .round() as int);

    _totalDelivery = 0;
    for (int count = 0; count < _cartItemsList!.length; count++) {
      if (count == 0 ||
          _cartItemsList!.values.elementAt(count)[6].toString() !=
              _cartItemsList!.values.elementAt(count - 1)[6].toString()) {
        _totalDelivery += _cartItemsList!.values.elementAt(count)[5] as int;
      }
    }

    _totalPriceNotifier.value = _totalPrice;
    _totalDeliveryNotifier.value = _totalDelivery;
  }

  //* Get document data of scpecific product
  getItemDocument(index) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(_cartItemsList!.values.elementAt(index)[11])
        .collection(_cartItemsList!.values.elementAt(index)[11])
        .doc(_cartItemsList!.values.elementAt(index)[0])
        .get()
        .then((value) {
      print(value.data()!["product-name"]);
      productData = value;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CartItems().getCartItemsList(),
      builder: (_, AsyncSnapshot snapshot) {
        if (_cartItemsList == null) _cartItemsList = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          //* Get total price
          _cartItemsList!.values.forEach((item) => _totalPrice +=
              ((item[4] != 0)
                      ? (item[3] * ((100 - item[4]) / 100)) * item[8]
                      : item[3] * item[8])
                  .round() as int);

          //* Get total delivery price
          for (int count = 0; count < _cartItemsList!.length; count++) {
            if (count == 0 ||
                _cartItemsList!.values.elementAt(count)[6].toString() !=
                    _cartItemsList!.values.elementAt(count - 1)[6].toString()) {
              _totalDelivery +=
                  _cartItemsList!.values.elementAt(count)[5] as int;
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Container(
                  alignment: Alignment.topCenter,
                  //* Cart Items list section ----------------------------------------------------
                  child: ScrollGlowDisabler(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _cartItemsList!.length,
                        itemBuilder: (_, int index) {
                          int? _quantity =
                              _cartItemsList!.values.elementAt(index)[8];
                          print(_totalPrice);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* Store name -----------------------------------------------------
                              if (index == 0 ||
                                  _cartItemsList!.values
                                          .elementAt(index)[6]
                                          .toString() !=
                                      _cartItemsList!.values
                                          .elementAt(index - 1)[6]
                                          .toString())
                                Container(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Text(
                                    _cartItemsList!.values
                                        .elementAt(index)[6]
                                        .toString(),
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
                                //* Product Card ---------------------------------------------------
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  color: Colors.white,
                                  elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //* Product Image
                                          child: InkWell(
                                            child: Image.network(
                                              _cartItemsList!.values
                                                  .elementAt(index)[2]
                                                  .toString(),
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                            //* Navigate to product page
                                            onTap: () async {
                                              await getItemDocument(index);
                                              print('tapped');
                                              Route route = SlideLeftTransition(
                                                widget: ProductDetailsScreen(
                                                    productData: productData,
                                                    category: _cartItemsList!
                                                        .values
                                                        .elementAt(index)[11]),
                                              );
                                              Navigator.pushReplacement(
                                                  context, route);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Flexible(
                                          //* Product details
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //* Product name
                                              InkWell(
                                                child: Text(
                                                  _cartItemsList!.values
                                                      .elementAt(index)[1]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'sf',
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                                //* Navigate to product page
                                                onTap: () async {
                                                  await getItemDocument(index);
                                                  print('tapped');
                                                  Route route =
                                                      SlideLeftTransition(
                                                    widget: ProductDetailsScreen(
                                                        productData:
                                                            productData,
                                                        category:
                                                            _cartItemsList!
                                                                .values
                                                                .elementAt(
                                                                    index)[11]),
                                                  );
                                                  Navigator.pushReplacement(
                                                      context, route);
                                                },
                                              ),
                                              StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return Container(
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //* Quantity Section
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //* Product size
                                                            Text(
                                                              _cartItemsList!
                                                                  .values
                                                                  .elementAt(
                                                                      index)[9]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'sf',
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff808080),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                                                        size:
                                                                            17),
                                                                    onTap: () {
                                                                      if (_quantity! >
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          _quantity =
                                                                              _quantity! - 1;
                                                                        });
                                                                        _cartItemsList!
                                                                            .values
                                                                            .elementAt(index)[8] -= 1;
                                                                        CartItems().updateCart(
                                                                            itemDataMap:
                                                                                _cartItemsList,
                                                                            quantityDiff:
                                                                                -1);
                                                                        getTotal();
                                                                      }
                                                                    },
                                                                  ),
                                                                  //* Quantity
                                                                  Text(
                                                                    _quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'sf',
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  //* Add button
                                                                  InkWell(
                                                                    child: Icon(
                                                                        Icons
                                                                            .add_circle_outline_rounded,
                                                                        size:
                                                                            17),
                                                                    onTap: () {
                                                                      if (_quantity! <
                                                                          int.parse(_cartItemsList!
                                                                              .values
                                                                              .elementAt(index)[10]
                                                                              .toString())) {
                                                                        setState(
                                                                            () {
                                                                          _quantity =
                                                                              _quantity! + 1;
                                                                        });
                                                                        _cartItemsList!
                                                                            .values
                                                                            .elementAt(index)[8] += 1;
                                                                        CartItems().updateCart(
                                                                            itemDataMap:
                                                                                _cartItemsList,
                                                                            quantityDiff:
                                                                                1);
                                                                        getTotal();
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
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            //* Discounted price
                                                            Text(
                                                              "Rs. " +
                                                                  NumberFormat(
                                                                          '###,000')
                                                                      .format((int.parse(_cartItemsList!.values.elementAt(index)[4].toString()) != 0)
                                                                          ? ((int.parse(_cartItemsList!.values.elementAt(index)[3].toString())) * ((100 - int.parse(_cartItemsList!.values.elementAt(index)[4].toString())) / 100)) *
                                                                              _quantity!
                                                                          : int.parse(_cartItemsList!.values.elementAt(index)[3].toString()) *
                                                                              _quantity!)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'sf',
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff808080),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            //* Real price
                                                            if (int.parse(snapshot
                                                                    .data.values
                                                                    .elementAt(
                                                                        index)[4]
                                                                    .toString()) !=
                                                                0)
                                                              Text(
                                                                "Rs. " +
                                                                    NumberFormat(
                                                                            '###,000')
                                                                        .format(int.parse(_cartItemsList!.values.elementAt(index)[3].toString()) *
                                                                            _quantity!)
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'sf',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xaa808080),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              ),
                                                            //* Shipping price
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                (index == 0 ||
                                                                        _cartItemsList!.values.elementAt(index)[6].toString() !=
                                                                            _cartItemsList!.values
                                                                                .elementAt(index - 1)[
                                                                                    6]
                                                                                .toString())
                                                                    ? '+ ' +
                                                                        _cartItemsList!
                                                                            .values
                                                                            .elementAt(index)[5]
                                                                            .toString()
                                                                    : 'Free shipping',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'sf',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xff505050),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
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
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  child: Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        fontFamily: 'sf',
                                                        fontSize: 12,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _cartItemsList!.remove(
                                                          _cartItemsList!.keys
                                                              .elementAt(
                                                                  index));
                                                    });
                                                    CartItems().updateCart(
                                                        itemDataMap:
                                                            _cartItemsList,
                                                        quantity: _quantity);
                                                    // print('items' +
                                                    //     _cartItemsList
                                                    //         .toString());
                                                    if (_cartItemsList!.isEmpty)
                                                      Navigator.pop(context);
                                                    getTotal();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5)
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                height: 24,
              ),
              //* Total Price section ----------------------------------------------------------
              Container(
                child: ValueListenableBuilder<int>(
                  valueListenable: _totalPriceNotifier,
                  builder: (BuildContext context, int price, Widget? child) {
                    return Column(
                      children: [
                        //* Total price of products
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Rs. " +
                                  NumberFormat('###,000')
                                      .format(
                                          (price == 0) ? _totalPrice : price)
                                      .toString(),
                              style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        ValueListenableBuilder<int>(
                          valueListenable: _totalDeliveryNotifier,
                          builder: (BuildContext context, int delivery,
                              Widget? child) {
                            return Column(children: [
                              //* Total price of delivery
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 15,
                                        color: Color(0xff606060),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Rs. " +
                                        NumberFormat('###,000')
                                            .format((delivery == 0)
                                                ? _totalDelivery
                                                : delivery)
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 15,
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                height: 8,
                              ),
                              //* Sub total of cart (Total product price + Delivery price)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Rs. " +
                                        NumberFormat('###,000')
                                            .format(((price == 0)
                                                    ? _totalPrice
                                                    : price) +
                                                ((delivery == 0)
                                                    ? _totalDelivery
                                                    : delivery))
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              //* Go to checkout button ------------------------------------------------------------
              Container(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.grey,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {},
                  child: Text(
                    "Go to checkout",
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
