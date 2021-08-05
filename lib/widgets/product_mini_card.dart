import 'package:Apparel_App/screens/product_details_screen.dart';
import 'package:Apparel_App/transitions/slide_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductMiniCard extends StatelessWidget {
  final productData;
  final int quantity;
  final String category;
  final String size;
  const ProductMiniCard(
      {Key? key,
      required this.productData,
      required this.quantity,
      required this.category,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      color: Color(0xffF3F3F3),
      elevation: 0,
      child: InkWell(
        onTap: () {
          print('tapped');
          Route route = SlideLeftTransition(
            widget: ProductDetailsScreen(
              productData: productData,
              category: category,
            ),
          );
          Navigator.push(context, route);
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //* Product Image
                child: Image.network(
                  productData['images'][0].toString(),
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                //* Product details
                child: Container(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Product name
                      Text(
                        productData['product-name'],
                        style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                //* Product size
                                Text(
                                  size,
                                  style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 15,
                                      color: Color(0xff808080),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                //* Quantity
                                Text(
                                  'Quantity  ' + quantity.toString(),
                                  style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 14,
                                    color: Color(0xff808080),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //* Discounted price
                                Text(
                                  "Rs. " +
                                      NumberFormat('###,000')
                                          .format((int.parse(
                                                      productData['discount']
                                                          .toString()) !=
                                                  0)
                                              ? ((int.parse(productData['price']
                                                          .toString())) *
                                                      ((100 -
                                                              int.parse(productData[
                                                                      'discount']
                                                                  .toString())) /
                                                          100)) *
                                                  quantity
                                              : int.parse(productData['price']
                                                      .toString()) *
                                                  quantity)
                                          .toString(),
                                  style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 16,
                                      color: Color(0xff808080),
                                      fontWeight: FontWeight.w700),
                                ),
                                //* Real price
                                if (int.parse(
                                        productData['discount'].toString()) !=
                                    0)
                                  Text(
                                    "Rs. " +
                                        NumberFormat('###,000')
                                            .format(int.parse(
                                                    productData['price']
                                                        .toString()) *
                                                quantity)
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 12,
                                        color: Color(0xaa808080),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                //* Shipping price
                                // Container(
                                //   alignment:
                                //       Alignment
                                //           .topRight,
                                //   child: Text(
                                //     (index == 0 ||
                                //             _cartItemsList!.values.elementAt(index)[6].toString() !=
                                //                 _cartItemsList!.values
                                //                     .elementAt(index - 1)[
                                //                         6]
                                //                     .toString())
                                //         ? '+ ' +
                                //             _cartItemsList!
                                //                 .values
                                //                 .elementAt(index)[5]
                                //                 .toString()
                                //         : 'Free shipping',
                                //     style: TextStyle(
                                //         fontFamily:
                                //             'sf',
                                //         fontSize:
                                //             12,
                                //         color: Color(
                                //             0xff505050),
                                //         fontWeight:
                                //             FontWeight
                                //                 .w400),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
