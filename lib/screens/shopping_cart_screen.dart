import 'dart:io';

import 'package:Apparel_App/widgets/shopping_cart_list.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, (Platform.isAndroid) ? 35 : 50, 20, 10),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close_rounded,
                  size: 32,
                  color: Color(0xff646464),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Topic --------------------------------------------------------------------
                    Container(
                      // padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                      child: Text(
                        'Shopping Cart',
                        style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    //* Shopping Cart List -----------------------------------------------------------
                    Flexible(child: ShoppingCartList()),
                    SizedBox(height: (Platform.isAndroid) ? 0 : 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
