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
        padding: EdgeInsets.fromLTRB(0, 30, 20, 10),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.close),
              onTap: () => Navigator.pop(context),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Sign in Topic --------------------------------------------------------------------
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
                  // SizedBox(height: 10),
                  ShoppingCartList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
