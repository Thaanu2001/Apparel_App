import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  CheckoutScreen({
    Key? key,
    required this.productData,
    required this.isBuyNow,
    this.category,
    this.quantity,
    this.selectedSize,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String userId;
  bool isCashOnDelivery = true;
  Map userDocument = {};
  int? shippingPrice = 0;
  String? storeLocation;
  int fixedWeightPrice = 50;

  @override
  void initState() {
    userId = AuthService().getUser();
    super.initState();
  }

  //* Get shipping price -----------------------------------------------------------------
  Future getShipping() async {
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds1;
    DocumentSnapshot ds2;
    double totalWeight;

    //* Get store location
    ds1 = await firestore
        .collection('stores')
        .doc(widget.productData['store-id'])
        .get();

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
      totalWeight = double.parse(
          (widget.productData['weight'] * widget.quantity!).toStringAsFixed(2));

      shippingPrice = ((ds2.data() as Map)[storeLocation]) +
          ((totalWeight.ceil() - 1) * fixedWeightPrice);
    });

    return shippingPrice;
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
              padding:
                  EdgeInsets.fromLTRB(0, (Platform.isAndroid) ? 35 : 50, 0, 10),
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
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  userDocument = snapshot.data!.data() as Map;
                                if (userDocument.containsKey('shipping')) {
                                  //* Shows shipping address if available
                                  return Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 25),
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
                            shippingUpdateModal(context, userId);
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
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
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
                                color: (isCashOnDelivery)
                                    ? Colors.black
                                    : Color(0xffF3F3F3),
                              ),
                              //* Cash on delivery button
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Icon(
                                      Customicons.delivery,
                                      color: (isCashOnDelivery)
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Cash on Delivery",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: (isCashOnDelivery)
                                              ? Colors.white
                                              : Colors.black,
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
                                color: (isCashOnDelivery)
                                    ? Color(0xffF3F3F3)
                                    : Colors.black,
                              ),
                              //* Card payment button
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Icon(
                                      Customicons.card,
                                      color: (isCashOnDelivery)
                                          ? Colors.black
                                          : Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Card Payment",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: (isCashOnDelivery)
                                              ? Colors.black
                                              : Colors.white,
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
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8),
                      //* Product Cards list
                      FutureBuilder(
                        future: getShipping(),
                        builder: (context, snapshot) {
                          return (widget.isBuyNow)
                              ? ProductMiniCard(
                                  productData: widget.productData,
                                  quantity: widget.quantity as int,
                                  category: widget.category as String,
                                  size: widget.selectedSize as String,
                                  shippingPrice: shippingPrice as int,
                                )
                              : Container();
                        },
                      ),
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
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Rs. " +
                            NumberFormat('###,000')
                                .format((int.parse(widget.productData['discount']
                                            .toString()) !=
                                        0)
                                    ? ((int.parse(widget.productData['price']
                                                .toString())) *
                                            ((100 -
                                                    int.parse(widget
                                                        .productData['discount']
                                                        .toString())) /
                                                100)) *
                                        int.parse(widget.quantity.toString())
                                    : int.parse(
                                            widget.productData['price'].toString()) *
                                        int.parse(widget.quantity.toString()))
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
                  Column(
                    children: [
                      //* Total price of delivery
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            (shippingPrice != 0)
                                ? "Rs. " +
                                    NumberFormat('###,000')
                                        .format(shippingPrice)
                                        .toString()
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
                                    .format((int.parse(widget.productData['discount'].toString()) != 0)
                                        ? ((int.parse(widget.productData['price'].toString())) *
                                                    ((100 -
                                                            int.parse(widget
                                                                .productData[
                                                                    'discount']
                                                                .toString())) /
                                                        100)) *
                                                int.parse(widget.quantity
                                                    .toString()) +
                                            (shippingPrice as int)
                                        : int.parse(widget.productData['price'].toString()) *
                                                int.parse(widget.quantity.toString()) +
                                            (shippingPrice as int))
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
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {},
                child: Text(
                  (isCashOnDelivery) ? 'Place Order' : 'Proceed to Pay',
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
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
