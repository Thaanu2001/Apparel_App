import 'dart:io';
import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/widgets/shipping_update_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/auth_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String userId;
  bool isCashOnDelivery = true;

  @override
  void initState() {
    userId = AuthService().getUser();
    print(userId);
    super.initState();
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
            Container(
              padding: EdgeInsets.only(top: 10),
              child: InkWell(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      Map userDocument = {};
                      if (snapshot.hasData)
                        userDocument = snapshot.data!.data() as Map;
                      if (userDocument.containsKey('shipping')) {
                        return Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                  shippingUpdateModal(context, userId);
                },
              ),
            ),
            Divider(
              height: 25,
              thickness: 1.6,
              color: Color(0XFFE3E3E3),
            ),
            Text(
              "Payment Method",
              style: TextStyle(
                  fontFamily: 'sf',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            // SizedBox(height: 4),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          (isCashOnDelivery) ? Colors.black : Color(0xffF3F3F3),
                    ),
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
                      color:
                          (isCashOnDelivery) ? Color(0xffF3F3F3) : Colors.black,
                    ),
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
            Text(
              "Products",
              style: TextStyle(
                  fontFamily: 'sf',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
