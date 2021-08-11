import 'package:Apparel_App/global_variables.dart';
import 'package:flutter/material.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAccentColor,
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: mainAccentDarkColor,
                child: Image.asset(
                  'lib/assets/order-placed.webp',
                  height: 120,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Order Placed!',
                style: TextStyle(
                  fontFamily: 'sf',
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Your order is succesfully placed.\nPlease check delivery status at\n',
                  style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Order Tracking ',
                      style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'page',
                      style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              //* Back to home button -------------------------------------------------------------------
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 40),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.grey,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                  child: Text(
                    "Continue Shopping",
                    style:
                        TextStyle(fontFamily: 'sf', fontSize: 18, color: mainAccentColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white, width: 2)),
                    primary: Colors.grey,
                    backgroundColor: mainAccentColor,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Order Tracking",
                    style: TextStyle(fontFamily: 'sf', fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
