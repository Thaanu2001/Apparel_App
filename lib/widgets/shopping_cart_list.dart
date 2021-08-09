import 'package:Apparel_App/calculations/cart_total_price.dart';
import 'package:Apparel_App/models/shipping_update_modal.dart';
import 'package:Apparel_App/screens/product_details_screen.dart';
import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/services/cart_items.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartList extends StatefulWidget {
  @override
  _ShoppingCartListState createState() => _ShoppingCartListState();
}

class _ShoppingCartListState extends State<ShoppingCartList> {
  List? _cartItemsList;
  List? shippingCostList;
  Map? userLocation;
  ValueNotifier<int> _totalPriceNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> _totalDeliveryNotifier = ValueNotifier<int>(0);
  ValueNotifier<List> _shippingNotifier = ValueNotifier<List>([]);
  DocumentSnapshot? productData;
  String? userId;
  int _totalPrice = 0;

  @override
  void initState() {
    userId = AuthService().getUser();
    _cartItemsList = null;
    _totalPrice = 0;
    _totalPriceNotifier.value = 0;
    _totalDeliveryNotifier.value = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: ScrollGlowDisabler(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: CartItems().getCartProductList(),
                builder: (_, AsyncSnapshot snapshot) {
                  if (_cartItemsList == null) {
                    _cartItemsList = snapshot.data;
                  }

                  //* Calculate total price after state builds
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    _totalPriceNotifier.value =
                        CartCalculations().getTotal(cartItemsList: _cartItemsList, totalPrice: _totalPrice);
                  });

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          //* Cart Items list section ----------------------------------------------------
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _cartItemsList!.length,
                            itemBuilder: (_, int index) {
                              //* selected _quantity
                              int? _quantity = _cartItemsList![index]['selectedQuantity'];

                              //* Get size index according to documentSnapshot
                              int? sizeIndex = _cartItemsList![index]['productDoc']
                                  .data()['size']['size']
                                  .indexOf(_cartItemsList![index]['selectedSize']);

                              //* Get max stocks available
                              int? maxQuantity = _cartItemsList![index]['productDoc'].data()['size']['qty'][sizeIndex];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //* Store name -----------------------------------------------------
                                  if (index == 0 ||
                                      _cartItemsList![index]['productDoc'].data()['store-name'] !=
                                          _cartItemsList![index - 1]['productDoc'].data()['store-name'])
                                    Container(
                                      padding: EdgeInsets.only(top: 7),
                                      child: Text(
                                        _cartItemsList![index]['productDoc'].data()['store-name'].toString(),
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
                                              child: InkWell(
                                                child: Image.network(
                                                  _cartItemsList![index]['productDoc'].data()['images'][0].toString(),
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                                //* Navigate to product page
                                                onTap: () async {
                                                  Route route = SlideLeftTransition(
                                                    widget: ProductDetailsScreen(
                                                        productData: _cartItemsList![index]['productDoc'],
                                                        category: _cartItemsList![index]['category']),
                                                  );
                                                  Navigator.push(context, route);
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Flexible(
                                              //* Product details
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //* Product name
                                                  InkWell(
                                                    child: Text(
                                                      _cartItemsList![index]['productDoc']
                                                          .data()['product-name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily: 'sf', fontSize: 15, color: Colors.black),
                                                    ),
                                                    //* Navigate to product page
                                                    onTap: () async {
                                                      Route route = SlideLeftTransition(
                                                          widget: ProductDetailsScreen(
                                                              productData: _cartItemsList![index]['productDoc'],
                                                              category: _cartItemsList![index]['category']));
                                                      Navigator.push(context, route);
                                                    },
                                                  ),
                                                  StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return Container(
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            //* quantity Section
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                //* Product size
                                                                Text(
                                                                  _cartItemsList![index]['selectedSize'].toString(),
                                                                  style: TextStyle(
                                                                      fontFamily: 'sf',
                                                                      fontSize: 14,
                                                                      color: Color(0xff808080),
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                                SizedBox(height: 2),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      //* Minus Button
                                                                      InkWell(
                                                                        child: Icon(Icons.remove_circle_outline_rounded,
                                                                            size: 20),
                                                                        onTap: () {
                                                                          if (_quantity! > 1) {
                                                                            setState(() {
                                                                              _quantity = _quantity! - 1;
                                                                            });
                                                                            _cartItemsList![index]
                                                                                ['selectedQuantity'] -= 1;
                                                                            CartItems().updateCart(
                                                                                itemIndex: index, quantityDiff: -1);
                                                                            _totalPriceNotifier.value =
                                                                                CartCalculations().getTotal(
                                                                                    cartItemsList: _cartItemsList,
                                                                                    totalPrice: _totalPrice);
                                                                          }
                                                                        },
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      //* _quantity
                                                                      Text(
                                                                        (_quantity! <= (maxQuantity as int))
                                                                            ? _quantity.toString()
                                                                            : maxQuantity.toString(),
                                                                        style: TextStyle(
                                                                            fontFamily: 'sf',
                                                                            fontSize: 18,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      //* Add button
                                                                      InkWell(
                                                                        child: Icon(Icons.add_circle_outline_rounded,
                                                                            size: 20),
                                                                        onTap: () {
                                                                          if (_quantity! < (maxQuantity)) {
                                                                            setState(() {
                                                                              _quantity = _quantity! + 1;
                                                                            });
                                                                            _cartItemsList![index]
                                                                                ['selectedQuantity'] += 1;
                                                                            CartItems().updateCart(
                                                                                itemIndex: index, quantityDiff: 1);
                                                                            _totalPriceNotifier.value =
                                                                                CartCalculations().getTotal(
                                                                                    cartItemsList: _cartItemsList,
                                                                                    totalPrice: _totalPrice);
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (_quantity == maxQuantity)
                                                                  Text(
                                                                    'Only $maxQuantity stocks left',
                                                                    style: TextStyle(
                                                                        fontFamily: 'sf',
                                                                        fontSize: 12,
                                                                        color: Colors.red,
                                                                        fontWeight: FontWeight.w400),
                                                                  ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                //* Discounted price
                                                                Text(
                                                                  "Rs. " +
                                                                      NumberFormat('###,000')
                                                                          .format((int.parse(_cartItemsList![index]
                                                                                          ['productDoc']
                                                                                      .data()['discount']
                                                                                      .toString()) !=
                                                                                  0)
                                                                              ? ((int.parse(_cartItemsList![index]
                                                                                              ['productDoc']
                                                                                          .data()['price']
                                                                                          .toString())) *
                                                                                      ((100 -
                                                                                              int.parse(_cartItemsList![index]
                                                                                                      ['productDoc']
                                                                                                  .data()['discount']
                                                                                                  .toString())) /
                                                                                          100)) *
                                                                                  _quantity!
                                                                              : int.parse(_cartItemsList![index]['productDoc'].data()['price'].toString()) *
                                                                                  _quantity!)
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily: 'sf',
                                                                      fontSize: 14,
                                                                      color: Color(0xff808080),
                                                                      fontWeight: FontWeight.w700),
                                                                ),
                                                                //* Real price
                                                                if (int.parse(_cartItemsList![index]['productDoc']
                                                                        .data()['discount']
                                                                        .toString()) !=
                                                                    0)
                                                                  Text(
                                                                    "Rs. " +
                                                                        NumberFormat('###,000')
                                                                            .format(int.parse(_cartItemsList![index]
                                                                                        ['productDoc']
                                                                                    .data()['price']
                                                                                    .toString()) *
                                                                                _quantity!)
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily: 'sf',
                                                                        fontSize: 12,
                                                                        color: Color(0xaa808080),
                                                                        fontWeight: FontWeight.w500,
                                                                        decoration: TextDecoration.lineThrough),
                                                                  ),
                                                                //* Shipping price
                                                                FutureBuilder(
                                                                  future: CartCalculations().getShipping(
                                                                      cartItemsList: _cartItemsList as List,
                                                                      userId: userId as String),
                                                                  builder: (context, snapshot) {
                                                                    if (snapshot.hasData) {
                                                                      List snapData = snapshot.data as List;
                                                                      userLocation = snapData[1];

                                                                      //* Calculate total price after state builds
                                                                      SchedulerBinding.instance!
                                                                          .addPostFrameCallback((_) {
                                                                        _shippingNotifier.value = snapData[0];
                                                                        _totalDeliveryNotifier.value = snapData[0]
                                                                            .reduce(
                                                                                (value, element) => value + element);
                                                                      });

                                                                      return ValueListenableBuilder<List>(
                                                                          valueListenable: _shippingNotifier,
                                                                          builder: (BuildContext context, List shipping,
                                                                              Widget? child) {
                                                                            return Container(
                                                                              alignment: Alignment.topRight,
                                                                              child: Text(
                                                                                (shipping.isNotEmpty &&
                                                                                        shipping[index] != 0)
                                                                                    ? '+ Delivery ' +
                                                                                        shipping[index].toString()
                                                                                    : 'Free Delivery',
                                                                                style: TextStyle(
                                                                                    fontFamily: 'sf',
                                                                                    fontSize: 12,
                                                                                    color: Color(0xff505050),
                                                                                    fontWeight: FontWeight.w400),
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      return Container(
                                                                        alignment: Alignment.topRight,
                                                                        child: Text(
                                                                          'Calculating',
                                                                          style: TextStyle(
                                                                              fontFamily: 'sf',
                                                                              fontSize: 12,
                                                                              color: Color(0xff505050),
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                )
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
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          _cartItemsList!.removeAt(index);
                                                        });
                                                        CartItems().updateCart(itemIndex: index, quantity: _quantity);
                                                        if (_cartItemsList!.isEmpty) {
                                                          Navigator.pop(context);
                                                          cartQuantity.value = 0;
                                                        }
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
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Column(
          children: [
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
                                fontFamily: 'sf', fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Rs. " + NumberFormat('###,000').format((price == 0) ? _totalPrice : price).toString(),
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
                        builder: (BuildContext context, int delivery, Widget? child) {
                          return Column(
                            children: [
                              //* Total price of delivery
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Delivery ',
                                          style: TextStyle(
                                              fontFamily: 'sf',
                                              fontSize: 15,
                                              color: Color(0xff606060),
                                              fontWeight: FontWeight.w500),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: (userLocation != null)
                                                  ? '${userLocation!['city']}, ${userLocation!['district']} (change)'
                                                  : '',
                                              style: TextStyle(
                                                fontFamily: 'sf',
                                                fontSize: 14,
                                                color: Colors.red[400],
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        shippingUpdateModal(context, userId, () {
                                          setState(() {});
                                        });
                                      }),
                                  Text(
                                    (delivery != 0)
                                        ? "Rs. " + NumberFormat('###,000').format(delivery).toString()
                                        : 'Calculating',
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            .format(((price == 0) ? _totalPrice : price) + (delivery))
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
                            ],
                          );
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
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('cartItems');
                  prefs.remove('cartItem_quantity');
                },
                child: Text(
                  "Go to checkout",
                  style: TextStyle(fontFamily: 'sf', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
