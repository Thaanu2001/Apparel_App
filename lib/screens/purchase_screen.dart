import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseScreen extends StatefulWidget {
  final productData;
  final isBuyNow;
  PurchaseScreen({@required this.productData, @required this.isBuyNow});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  GlobalKey<FormFieldState> _key = GlobalKey();
  String selectedSize;
  int _quantity = 0;
  String errorMsg;
  bool errorVisible = false;
  List<String> sizeList = [];
  bool expanded = false;

  var size = {
    'size': ['Small', 'Medium', 'Large', 'X-Large', 'XX-Large'],
    'qty': [8, 10, 0, 12, 10]
  };

  //* Get Size list for Drop down
  getSizeList() {
    print(widget.productData['size-table']);
    print(widget.productData["size"].length);
    var sortedKeys = widget.productData["size"].keys.toList()..sort();
    print(sortedKeys);

    for (int count = 0;
        count < widget.productData['size']["size"].length;
        count++) {
      if (size['qty'][count] != 0) {
        sizeList.add(widget.productData['size']["size"][count]);
      } else {
        sizeList.add(widget.productData['size']["size"][count].toString() +
            " (Sold out)");
      }
    }
    // for (int count = 0; count < widget.productData["size"].length; count++) {
    //   if (widget.productData["size"]
    //           [widget.productData["size"].keys.elementAt(count)] !=
    //       0) {
    //     sizeList.add(widget.productData["size"].keys.elementAt(count));
    //   } else {
    //     sizeList.add(
    //         widget.productData["size"].keys.elementAt(count) + " (Sold out)");
    //   }
    // }
    print(sizeList);
  }

  //* Table topic text widget
  tableTopicWidget(
      {@required text, @required isBold, textAlign = TextAlign.center}) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: (textAlign == TextAlign.left) ? 4 : 0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: 'sf',
            fontWeight: (isBold) ? FontWeight.w700 : FontWeight.w400),
      ),
    );
  }

  @override
  void initState() {
    getSizeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        padding: EdgeInsets.fromLTRB(0, 30, 20, 10),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Wrap(
          children: <Widget>[
            InkWell(
              child: Icon(Icons.close),
              onTap: () => Navigator.pop(context),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Product Image
                  Hero(
                    tag: 'test',
                    child: Image.network(
                      widget.productData["images"][0],
                      height: 120,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* Name
                        Text(
                          widget.productData["product-name"],
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 3),
                        //* Price
                        Text(
                          "Rs. " +
                              NumberFormat('###,000')
                                  .format((widget.productData["discount"] != 0)
                                      ? ((widget.productData["price"]) *
                                          ((100 -
                                                  widget.productData[
                                                      "discount"]) /
                                              100))
                                      : widget.productData["price"])
                                  .toString(),
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 20,
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w800),
                        ),
                        //* Discount old price
                        if (widget.productData["discount"] != 0)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rs. " +
                                    NumberFormat('###,000')
                                        .format(widget.productData["price"])
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 12,
                                    color: Color(0xffacacac),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "-" +
                                    widget.productData["discount"].toString() +
                                    "%",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 10,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        //* Quantity Section
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 2, 0, 4),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //* Minus Button
                              InkWell(
                                child: Icon(Icons.remove_circle_outline_rounded,
                                    size: 23),
                                onTap: () {
                                  if (_quantity > 0) {
                                    setState(() {
                                      errorVisible = false;
                                      _quantity--;
                                    });
                                  }
                                },
                              ),
                              //* Quantity
                              Text(
                                (_quantity == 0) ? 'Qty' : _quantity.toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              //* Add button
                              InkWell(
                                child: Icon(Icons.add_circle_outline_rounded,
                                    size: 23),
                                onTap: () {
                                  if (selectedSize == null ||
                                      _quantity <
                                          widget.productData["size"]["qty"][
                                              widget.productData["size"]["size"]
                                                  .indexOf(selectedSize)]) {
                                    setState(() {
                                      errorVisible = false;
                                      _quantity++;
                                    });
                                    if (selectedSize == null) {
                                    } else if (_quantity ==
                                        widget.productData["size"]["qty"][widget
                                            .productData["size"]["size"]
                                            .indexOf(selectedSize)]) {
                                      setState(() {
                                        errorVisible = true;
                                        errorMsg = 'Maximum quantity reached';
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Select size section
            Container(
              //* Select Size Dropdown ----------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
              width: double.infinity,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 8),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'sf',
                    fontSize: 16,
                  ),
                  filled: true,
                  labelText: 'Size',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: new BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                focusColor: Colors.black,
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
                items: sizeList.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 16,
                          color: (!value.contains('(Sold out)'))
                              ? Colors.black
                              : Color(0xffacacac),
                          fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedSize,
                key: _key,
                onChanged: (value) {
                  if ((!value.contains('(Sold out)'))) {
                    if (_quantity >
                        widget.productData["size"]["qty"][widget
                            .productData["size"]["size"]
                            .indexOf(value)]) {
                      setState(() {
                        selectedSize = value;
                        _quantity = widget.productData["size"]["qty"]
                            [widget.productData["size"]["size"].indexOf(value)];
                        errorVisible = true;
                        errorMsg = 'Maximum quantity reached';
                      });
                    } else {
                      setState(() {
                        selectedSize = value;
                        errorVisible = false;
                        if (_quantity == 0) _quantity = 1;
                      });
                    }
                  } else {
                    setState(() {
                      selectedSize = null;
                      _key.currentState.reset();
                      _quantity = 0;
                      errorVisible = false;
                    });
                  }
                },
              ),
            ),
            // //* Quantity Section
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 10, 0, 4),
            //   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 2),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       //* Minus Button
            //       InkWell(
            //         child: Icon(Icons.remove, size: 30),
            //         onTap: () {
            //           if (selectedSize == null) {
            //             setState(() {
            //               errorVisible = true;
            //               errorMsg = 'Please select size first';
            //             });
            //           }
            //           if (_quantity > 0) {
            //             setState(() {
            //               errorVisible = false;
            //               _quantity--;
            //             });
            //           }
            //         },
            //       ),
            //       //* Quantity
            //       Text(
            //         (_quantity == 0) ? 'Quantity' : _quantity.toString(),
            //         style: TextStyle(
            //             fontFamily: 'sf',
            //             fontSize: 20,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w600),
            //       ),
            //       //* Add button
            //       InkWell(
            //         child: Icon(Icons.add, size: 30),
            //         onTap: () {
            //           if (selectedSize == null) {
            //             setState(() {
            //               errorVisible = true;
            //               errorMsg = 'Please select size first';
            //             });
            //           } else if (_quantity <
            //               widget.productData["size"][selectedSize]) {
            //             setState(() {
            //               errorVisible = false;
            //               _quantity++;
            //             });
            //             if (_quantity ==
            //                 widget.productData["size"][selectedSize]) {
            //               setState(() {
            //                 errorVisible = true;
            //                 errorMsg = 'Maximum quantity reached';
            //               });
            //             }
            //           }
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            //* Quantity error message
            if (errorVisible)
              Container(
                padding: EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  errorMsg,
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500),
                ),
              ),
            //* View Size Chart Section ------------------------------------------------------
            // Container(
            //   padding: EdgeInsets.only(top: 10, left: 20),
            //   child: InkWell(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         //* View Size Chart Button
            //         Text(
            //           "View size chart",
            //           style: TextStyle(
            //               fontFamily: 'sf',
            //               fontSize: 16,
            //               color: Colors.black,
            //               fontWeight: FontWeight.w400),
            //         ),
            //         Container(
            //           padding: EdgeInsets.only(left: 10),
            //           child: Icon(
            //             Icons.arrow_forward_ios_rounded,
            //             color: Color(0xffc5c5c5),
            //             size: 15,
            //           ),
            //         ),
            //       ],
            //     ),
            //     onTap: () {},
            //   ),
            // ),
            //
            //* Size Chart Section
            Theme(
              data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  unselectedWidgetColor: Colors.grey,
                  accentColor: Colors.grey),
              child: ListTileTheme(
                contentPadding: EdgeInsets.zero,
                dense: true,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  childrenPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  //* View Size chart topic
                  title: Text(
                    "View size chart",
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  children: <Widget>[
                    //* Size chart content
                    Container(
                      width: double.infinity,
                      child: ScrollGlowDisabler(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Text('Recent Claims'),
                              Table(
                                border: TableBorder.all(color: Colors.black),
                                //* Column Width
                                columnWidths: {
                                  0: FixedColumnWidth(70.0),
                                  1: FixedColumnWidth(70.0),
                                  2: FixedColumnWidth(70.0),
                                  3: FixedColumnWidth(70.0),
                                  4: FixedColumnWidth(70.0),
                                  5: FixedColumnWidth(70.0),
                                  6: FixedColumnWidth(70.0),
                                  7: FixedColumnWidth(70.0),
                                  8: FixedColumnWidth(70.0),
                                },
                                children: [
                                  //* Table Topics
                                  TableRow(
                                    children: [
                                      tableTopicWidget(
                                          text: 'Topic',
                                          isBold: true,
                                          textAlign: TextAlign.left),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('XXS'))
                                        tableTopicWidget(
                                            text: 'XXS', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('XS'))
                                        tableTopicWidget(
                                            text: 'XS', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('S'))
                                        tableTopicWidget(
                                            text: 'S', isBold: true),
                                      tableTopicWidget(text: 'M', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('L'))
                                        tableTopicWidget(
                                            text: 'L', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('XL'))
                                        tableTopicWidget(
                                            text: 'XL', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('XXL'))
                                        tableTopicWidget(
                                            text: 'XXL', isBold: true),
                                      if (widget.productData['size-table'][0]
                                          .containsKey('XXXL'))
                                        tableTopicWidget(
                                            text: 'XXXL', isBold: true),
                                    ],
                                  ),
                                  //* Table Content
                                  for (var item
                                      in widget.productData['size-table'])
                                    TableRow(
                                      children: [
                                        tableTopicWidget(
                                            text: item['Topic'],
                                            isBold: true,
                                            textAlign: TextAlign.left),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('XXS'))
                                          tableTopicWidget(
                                              text: item['XXS'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('XS'))
                                          tableTopicWidget(
                                              text: item['XS'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('S'))
                                          tableTopicWidget(
                                              text: item['S'], isBold: false),
                                        tableTopicWidget(
                                            text: item['M'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('L'))
                                          tableTopicWidget(
                                              text: item['L'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('XL'))
                                          tableTopicWidget(
                                              text: item['XL'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('XXL'))
                                          tableTopicWidget(
                                              text: item['XXL'], isBold: false),
                                        if (widget.productData['size-table'][0]
                                            .containsKey('XXXL'))
                                          tableTopicWidget(
                                              text: item['XXL'], isBold: false),
                                      ],
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              ),
            ),
            //* Continue button -------------------------------------------------------------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20),
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                highlightColor: Color(0xff2e2e2e),
                color: Colors.black,
                onPressed: () {
                  // buyNowModal(context, widget.widget.productData);
                },
                child: Text(
                  (widget.isBuyNow == true) ? "Continue" : "Add to Cart",
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
