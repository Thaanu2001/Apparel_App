import 'package:Apparel_App/screens/shopping_cart_screen.dart';
import 'package:Apparel_App/transitions/slide_top_transition.dart';
import 'package:flutter/material.dart';

import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/services/cart_items.dart';

class ShoppingCartButton extends StatefulWidget {
  @override
  _ShoppingCartButtonState createState() => _ShoppingCartButtonState();
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  @override
  void initState() {
    getCartQuantity();
    super.initState();
  }

  //* Get count from shared preferences
  getCartQuantity() async {
    cartQuantity.value = await CartItems().getCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //* Listen to cart quantity ---------------------------------------------------------------------------
    return ValueListenableBuilder<int?>(
      valueListenable: cartQuantity,
      builder: (BuildContext context, int? value, Widget? child) {
        if (value != 0 && value != null)
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              //* Floating button
              FloatingActionButton(
                onPressed: () {
                  // CartItems().removeCartData();
                  Route route = SlideTopTransition(
                    widget: ShoppingCartScreen(),
                  );
                  Navigator.push(context, route);
                },
                child: const Icon(Customicons.shopping_cart, size: 28),
                backgroundColor: Color(0xff646464),
                elevation: 4,
              ),
              //* count bubble
              Container(
                padding: EdgeInsets.all(2),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                      fontFamily: 'sf',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        else
          return Container();
      },
    );
  }
}
