import 'dart:io';
import 'package:Apparel_App/calculations/cart_total_price.dart';
import 'package:Apparel_App/global_variables.dart';
import 'package:Apparel_App/screens/order_placed_screen.dart';
import 'package:Apparel_App/services/cart_items.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'package:Apparel_App/services/auth_service.dart';
import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/models/shipping_update_modal.dart';
import 'package:Apparel_App/widgets/product_mini_card.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  final productData;
  final isBuyNow;
  String? category;
  int? quantity;
  String? selectedSize;
  int? totalProductPrice;
  CheckoutScreen({
    Key? key,
    required this.productData,
    required this.isBuyNow,
    this.category,
    this.quantity,
    this.selectedSize,
    this.totalProductPrice,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String userId;
  Map userDocument = {};
  List? deliveryData;
  String? storeLocation;
  int? shippingPrice = 0;
  int fixedWeightPrice = 50;
  bool isCashOnDelivery = true;
  bool orderInProgress = false;

  @override
  void initState() {
    userId = AuthService().getUser();
    super.initState();
  }

  //* Get shipping price -----------------------------------------------------------------
  Future getSingleProductShipping() async {
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds1;
    DocumentSnapshot ds2;
    double totalWeight;

    //* Get store location
    ds1 = await firestore.collection('stores').doc(widget.productData['store-id']).get();

    storeLocation = (ds1.data() as Map)['location'];

    //* Get shipping price according to city
    ds2 = await firestore
        .collection('shipping')
        .doc(userDocument['shipping']['province'])
        .collection(userDocument['shipping']['province'])
        .doc(userDocument['shipping']['district'])
        .collection(userDocument['shipping']['district'])
        .doc(userDocument['shipping']['city'])
        .get();

    setState(() {
      totalWeight = double.parse((widget.productData['weight'] * widget.quantity!).toStringAsFixed(2));

      shippingPrice = ((ds2.data() as Map)[storeLocation]) + ((totalWeight.ceil() - 1) * fixedWeightPrice);
    });

    return shippingPrice;
  }

  //* Place the order (Cash on Delivery)
  Future placeCODOrder() async {
    List productDetails = [];
    int totalDelivery = 0;
    int i = 0;
    int count = 0;
    List productQty = [];

    if (!widget.isBuyNow) {
      //* Purchase cart items
      while (count < widget.productData.length || (count <= widget.productData.length && i != 0)) {
        //* Add same store products to array
        if (count < widget.productData.length &&
            (i == 0 ||
                widget.productData[count]['productDoc']['store-id'] ==
                    widget.productData[count - 1]['productDoc']['store-id'])) {
          productDetails.add({'product-id': widget.productData[count]['productId']});
          productDetails[i]['selectedSize'] = widget.productData[count]['selectedSize'];
          productDetails[i]['category'] = widget.productData[count]['category'];
          productDetails[i]['selectedQuantity'] = widget.productData[count]['selectedQuantity'];

          productDetails[i]['store-id'] = widget.productData[count]['productDoc']['store-id'];
          productDetails[i]['product-name'] = widget.productData[count]['productDoc']['product-name'];
          productDetails[i]['store-name'] = widget.productData[count]['productDoc']['store-name'];
          productDetails[i]['price'] = widget.productData[count]['productDoc']['price'];
          productDetails[i]['discount'] = widget.productData[count]['productDoc']['discount'];
          productDetails[i]['image'] = widget.productData[count]['productDoc']['images'][0];

          productDetails[i]['deliveryPrice'] = deliveryData![count];
          totalDelivery += deliveryData![count] as int;

          //* Change quantity of product
          int sizeData =
              widget.productData[count]['productDoc']['size']['size'].indexOf(productDetails[i]['selectedSize']);

          if (i == 0) productQty = widget.productData[count]['productDoc']['size']['qty'];

          productQty[sizeData] =
              widget.productData[count]['productDoc']['size']['qty'][sizeData] -= productDetails[i]['selectedQuantity'];

          i++;
          count++;
        } else {
          int totalPrice = 0;
          int totalQty = 0;

          //* Calculate total price of product
          productDetails.forEach(
            (element) {
              totalPrice += (((element['discount'] != 0)
                          ? (element['price'] * ((100 - element['discount']) / 100))
                          : (element['price'])) *
                      element['selectedQuantity'])
                  .round() as int;
            },
          );

          //* Upload data map to firestore
          await FirebaseFirestore.instance
              .collection('orders')
              .add({
                'user-id': userId,
                'placed-time': DateTime.now(),
                'products': productDetails,
                'shipping': userDocument['shipping'],
                'store-id': productDetails[i - 1]['store-id'],
                'price': totalPrice,
                'delivery': totalDelivery
              })
              .then((value) => print("Product Sold"))
              .catchError((error) => print("Failed to sell product: $error"));

          //* Decrease the quantity of product
          productDetails.forEach((e) => totalQty += e['selectedQuantity'] as int);
          print(totalQty);
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productDetails[i - 1]['category'])
              .collection(productDetails[i - 1]['category'])
              .doc(productDetails[i - 1]['product-id'])
              .update({'sold': FieldValue.increment(totalQty), 'size.qty': productQty});

          productDetails = [];
          totalDelivery = 0;
          i = 0;
        }
      }
      CartItems().removeCartData();
    } else {
      int totalPrice;
      //* Purchase single items (from Buy Now)
      productDetails.add({'product-id': widget.productData.id});
      productDetails[0]['selectedSize'] = widget.selectedSize;
      productDetails[0]['category'] = widget.category;
      productDetails[0]['selectedQuantity'] = widget.quantity;

      productDetails[0]['store-id'] = widget.productData['store-id'];
      productDetails[0]['product-name'] = widget.productData['product-name'];
      productDetails[0]['store-name'] = widget.productData['store-name'];
      productDetails[0]['price'] = widget.productData['price'];
      productDetails[0]['discount'] = widget.productData['discount'];
      productDetails[0]['image'] = widget.productData['images'][0];

      productDetails[0]['deliveryPrice'] = shippingPrice;

      //* Get total price of product
      totalPrice = ((int.parse(widget.productData['discount'].toString()) != 0)
              ? (widget.productData['price'] * ((100 - widget.productData['discount']) / 100)) * widget.quantity
              : widget.productData['price'] * widget.quantity)
          .round();

      //* Change quantity of product
      int sizeData = widget.productData['size']['size'].indexOf(productDetails[0]['selectedSize']);

      //* Decrease the quantity of product
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productDetails[0]['category'])
          .collection(productDetails[0]['category'])
          .doc(productDetails[0]['product-id'])
          .get()
          .then((DocumentSnapshot ds) {
        productQty = (ds.data()! as Map)['size']['qty'];
      });

      print(productQty);
      productQty[sizeData] = widget.productData['size']['qty'][sizeData] -= productDetails[0]['selectedQuantity'];

      //* Upload data map to firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .add({
            'user-id': userId,
            'placed-time': DateTime.now(),
            'products': productDetails,
            'shipping': userDocument['shipping'],
            'store-id': productDetails[0]['store-id'],
            'price': totalPrice,
            'delivery': shippingPrice
          })
          .then((value) => print("Product Sold"))
          .catchError((error) => print("Failed to sell product: $error"));

      //* Decrease the quantity of product
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productDetails[0]['category'])
          .collection(productDetails[0]['category'])
          .doc(productDetails[0]['product-id'])
          .update({'sold': FieldValue.increment(productDetails[0]['selectedQuantity']), 'size.qty': productQty});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, (Platform.isAndroid) ? 35 : 50, 0, 10),
              child: Stack(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 32,
                      color: Color(0xff646464),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  //* Sign up Topic --------------------------------------------------------------------
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: ScrollGlowDisabler(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: InkWell(
                          //* Shipping Address Section -------------------------------------------------------
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) userDocument = snapshot.data!.data() as Map;
                                if (userDocument.containsKey('shipping')) {
                                  //* Shows shipping address if available
                                  return Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //* Topic
                                            Text(
                                              "Shipping",
                                              style: TextStyle(
                                                  fontFamily: 'sf',
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              userDocument['shipping']['name'],
                                              style: TextStyle(
                                                  fontFamily: 'sf',
                                                  fontSize: 14,
                                                  height: 1.4,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              '${userDocument['shipping']['address']}, ${userDocument['shipping']['city']}, ${userDocument['shipping']['district']}, ${userDocument['shipping']['province']}\n${userDocument['shipping']['mobile']}',
                                              style: TextStyle(
                                                fontFamily: 'sf',
                                                fontSize: 14,
                                                height: 1.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xffc5c5c5),
                                        size: 20,
                                      )
                                    ],
                                  );
                                } else {
                                  //* Show add shipping addres button if address not available
                                  return Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 25, bottom: 25),
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey[400] as Color,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xffF3F3F3)),
                                    child: Text(
                                      '+ Add Shipping Address',
                                      style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                              }),
                          onTap: () {
                            shippingUpdateModal(context, userId, () => setState(() {}));
                            setState(() {});
                          },
                        ),
                      ),
                      Divider(
                        height: 25,
                        thickness: 1.6,
                        color: Color(0XFFE3E3E3),
                      ),
                      //* Payment method section ----------------------------------------------------
                      Text(
                        "Payment Method",
                        style:
                            TextStyle(fontFamily: 'sf', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (isCashOnDelivery) ? mainAccentColor : Color(0xffF3F3F3),
                              ),
                              //* Cash on delivery button
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Icon(
                                      Customicons.delivery,
                                      color: (isCashOnDelivery) ? Colors.white : mainAccentColor,
                                      size: 30,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Cash on Delivery",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: (isCashOnDelivery) ? Colors.white : mainAccentColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    isCashOnDelivery = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (isCashOnDelivery) ? Color(0xffF3F3F3) : mainAccentColor,
                              ),
                              //* Card payment button
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Icon(
                                      Customicons.card,
                                      color: (isCashOnDelivery) ? mainAccentColor : Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Card Payment",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: (isCashOnDelivery) ? mainAccentColor : Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    isCashOnDelivery = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 25,
                        thickness: 1.6,
                        color: Color(0XFFE3E3E3),
                      ),
                      //* Products Section --------------------------------------------------
                      Text(
                        "Products",
                        style:
                            TextStyle(fontFamily: 'sf', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8),
                      //* Product Cards list
                      FutureBuilder(
                        future: (widget.isBuyNow)
                            ? getSingleProductShipping()
                            : CartCalculations().getShipping(cartItemsList: widget.productData as List, userId: userId),
                        builder: (context, snapshot) {
                          List snapData = [];
                          if (snapshot.hasData && !widget.isBuyNow) {
                            snapData = snapshot.data as List;
                            deliveryData = snapData[0];
                            SchedulerBinding.instance!.addPostFrameCallback((_) {
                              setState(() {
                                shippingPrice = snapData[0].reduce((value, element) => value + element);
                              });
                            });
                          }
                          return (widget.isBuyNow)
                              //* Single product purchase
                              ? ProductMiniCard(
                                  productData: widget.productData,
                                  quantity: widget.quantity as int,
                                  category: widget.category as String,
                                  size: widget.selectedSize as String,
                                  shippingPrice: shippingPrice as int,
                                )
                              //* List of products from shopping cart
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.productData.length,
                                  itemBuilder: (_, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: ProductMiniCard(
                                        productData: widget.productData[index]['productDoc'],
                                        quantity: widget.productData[index]['selectedQuantity'] as int,
                                        category: widget.productData[index]['category'] as String,
                                        size: widget.productData[index]['selectedSize'] as String,
                                        shippingPrice: (snapData.length != 0) ? snapData[0][index] : 0,
                                      ),
                                    );
                                  },
                                );
                        },
                      )
                    ],
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
              child: Column(
                children: [
                  //* Total price of products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style:
                            TextStyle(fontFamily: 'sf', fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (widget.isBuyNow)
                            ? "Rs. " +
                                NumberFormat('###,000')
                                    .format((int.parse(widget.productData['discount'].toString()) != 0)
                                        ? ((int.parse(widget.productData['price'].toString())) *
                                                ((100 - int.parse(widget.productData['discount'].toString())) / 100)) *
                                            int.parse(widget.quantity.toString())
                                        : int.parse(widget.productData['price'].toString()) *
                                            int.parse(widget.quantity.toString()))
                                    .toString()
                            : "Rs. " + NumberFormat('###,000').format(widget.totalProductPrice).toString(),
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
                  Column(
                    children: [
                      //* Total price of delivery
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery',
                            style: TextStyle(
                                fontFamily: 'sf', fontSize: 15, color: Color(0xff606060), fontWeight: FontWeight.w500),
                          ),
                          Text(
                            (shippingPrice != 0)
                                ? "Rs. " + NumberFormat('###,000').format(shippingPrice).toString()
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
                                fontFamily: 'sf', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            (widget.isBuyNow)
                                ? "Rs. " +
                                    NumberFormat('###,000')
                                        .format((int.parse(widget.productData['discount'].toString()) != 0)
                                            ? ((int.parse(widget.productData['price'].toString())) *
                                                        ((100 - int.parse(widget.productData['discount'].toString())) /
                                                            100)) *
                                                    int.parse(widget.quantity.toString()) +
                                                (shippingPrice as int)
                                            : int.parse(widget.productData['price'].toString()) *
                                                    int.parse(widget.quantity.toString()) +
                                                (shippingPrice as int))
                                        .toString()
                                : "Rs. " +
                                    NumberFormat('###,000').format(widget.totalProductPrice! + (shippingPrice as int)),
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //* Confirm order/Proceed to pay button ------------------------------------------------------------
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Colors.grey,
                  backgroundColor: mainAccentColor,
                ),
                onPressed: () async {
                  setState(() {
                    orderInProgress = true;
                  });
                  await placeCODOrder();
                  setState(() {
                    orderInProgress = false;
                  });
                  Route route = CupertinoPageRoute(builder: (context) => OrderPlacedScreen());
                  Navigator.push(context, route);
                },
                child: (!orderInProgress)
                    ? Text(
                        (isCashOnDelivery) ? 'Place Order' : 'Proceed to Pay',
                        style:
                            TextStyle(fontFamily: 'sf', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            SizedBox(height: (Platform.isAndroid) ? 20 : 40),
          ],
        ),
      ),
    );
  }
}
