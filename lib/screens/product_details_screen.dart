import 'dart:ui';
import 'package:Apparel_App/screens/image_zoom_screen.dart';
import 'package:Apparel_App/services/sidebaricons_icons.dart';
import 'package:Apparel_App/widgets/product_description_modal.dart';
import 'package:Apparel_App/widgets/product_details_modal.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'package:Apparel_App/widgets/similar_products_list.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

List imgList;

class ProductDetailsScreen extends StatefulWidget {
  final productData; //* Get product data  from firstore document
  final category;
  ProductDetailsScreen({@required this.productData, @required this.category}) {
    imgList = productData.data()["images"];
  }

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _current = 0;

  //* Image list for slider -------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map((item) => Container(
                child: GestureDetector(
              child: Image.network(item, fit: BoxFit.cover, width: 2000),
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ImageZoom(
                            imageLink: item,
                            detailedHeroId: widget.productData.id,
                          ),
                      transitionDuration: Duration(milliseconds: 500)),
                );
                print(result);
                setState(() {
                  item = result;
                });
              },
            )))
        .toList();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      drawerScrimColor: Colors.transparent,
      //* Floating shopping cart button ---------------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Sidebaricons.shopping_cart, size: 28),
        backgroundColor: Color(0xff646464),
        elevation: 4,
      ),

      //* Side drawer ---------------------------------------------------------------------------------------------
      drawer: Theme(
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white.withOpacity(0.5)),
        child: Container(
            width: 240,
            child: Stack(children: [
              ClipRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: 250,
                      child: Text(" "),
                    )),
              ),
              Drawer(
                child: Column(
                  // Important: Remove any padding from the ListView.
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: double.infinity,
                      //* Drawer header
                      child: DrawerHeader(
                        child: Text(
                          'Gadget Doctor',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      leading: Icon(
                        Sidebaricons.bag,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: Align(
                        alignment: Alignment(-1.2, 0),
                        child: Text(
                          'My Orders',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      leading: Icon(
                        Icons.format_list_bulleted_rounded,
                        color: Colors.black,
                      ),
                      title: Align(
                        alignment: Alignment(-1.2, 0),
                        child: Text(
                          'Wish List',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 32),
                      leading: Icon(
                        Sidebaricons.settings,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: Align(
                        alignment: Alignment(-1.2, 0),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {},
                    ),
                    //* Sign Out button
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 5),
                          title: Transform.translate(
                            offset: Offset(-15, 0),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
      backgroundColor: Color(0xffF3F3F3),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //* Side menu icon ---------------------------------------------------------------------------
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    child: Icon(
                      Icons.menu_rounded,
                      size: 32,
                      color: Color(0xff646464),
                    ),
                    onTap: () => scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                //* Search bar --------------------------------------------------------------------------------
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 40,
                    // color: Colors.red,
                    child: TextField(
                      cursorColor: Color(0xff646464),
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Color(0xff646464),
                          fontWeight: FontWeight.w500),
                      decoration: new InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        suffixIcon: Icon(
                          Icons.search,
                          size: 28,
                          color: Color(0xff646464),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.red,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: ScrollGlowDisabler(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    child: Hero(
                      tag: widget.productData.id,
                      child: Stack(
                        children: [
                          //* Image carousel slider -------------------------------------------------------------
                          CarouselSlider(
                            items: imageSliders,
                            options: CarouselOptions(
                                initialPage: _current,
                                viewportFraction: 1,
                                height: MediaQuery.of(context).size.width,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          ),
                          //* Image count indicator
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              color: Colors.white54,
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Wrap(
                                  children: imgList.map((url) {
                                    int index = imgList.indexOf(url);
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current == index
                                            ? Color.fromRGBO(0, 0, 0, 0.9)
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* Product Name
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productData.data()["product-name"],
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
                                        .format((widget.productData
                                                    .data()["discount"] !=
                                                0)
                                            ? ((widget.productData
                                                    .data()["price"]) *
                                                ((100 -
                                                        widget.productData
                                                                .data()[
                                                            "discount"]) /
                                                    100))
                                            : widget.productData
                                                .data()["price"])
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 22,
                                    color: Color(0xff808080),
                                    fontWeight: FontWeight.w800),
                              ),
                              //* Discount old price
                              if (widget.productData.data()["discount"] != 0)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rs. " +
                                          NumberFormat('###,000')
                                              .format(widget.productData
                                                  .data()["price"])
                                              .toString(),
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 14,
                                          color: Color(0xffacacac),
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "-" +
                                          widget.productData
                                              .data()["discount"]
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 6),
                              //* Delivery details
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home Delivery, 5 - 8 Days",
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Rs. " +
                                        NumberFormat('###,000')
                                            .format((widget.productData
                                                .data()["delivery-price"]))
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 25,
                                thickness: 1.4,
                                color: Color(0XFFF3F3F3),
                              ),
                              //* Product Details ----------------------------------------------------------------------
                              InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Details",
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (widget.productData
                                                  .data()["product-details"]
                                                      ["brand"]
                                                  .contains("brand"))
                                                //* Brand Title
                                                Text(
                                                  "Brand",
                                                  style: TextStyle(
                                                      fontFamily: 'sf',
                                                      fontSize: 14,
                                                      height: 1.4,
                                                      color: Color(0xff808080),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              //* Type Title
                                              Text(
                                                "Type",
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    height: 1.4,
                                                    color: Color(0xff808080),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              //* Material Type
                                              Text(
                                                "Material",
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    height: 1.4,
                                                    color: Color(0xff808080),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 9,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //* Brand
                                              Text(
                                                widget.productData.data()[
                                                    "product-details"]["brand"],
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    height: 1.4,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              //* Type
                                              Text(
                                                widget.productData.data()[
                                                    "product-details"]["type"],
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    height: 1.4,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              //* Material
                                              Text(
                                                widget.productData.data()[
                                                        "product-details"]
                                                    ["material"],
                                                style: TextStyle(
                                                    fontFamily: 'sf',
                                                    fontSize: 14,
                                                    height: 1.4,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                    )
                                  ],
                                ),
                                onTap: () {
                                  productDetailsModal(
                                      context, widget.productData);
                                },
                              ),
                              Divider(
                                height: 25,
                                thickness: 1.4,
                                color: Color(0XFFF3F3F3),
                              ),
                              //* Product Description Section ------------------------------------------------------
                              InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //* Product Description Topic
                                          Text(
                                            "Product Description",
                                            style: TextStyle(
                                                fontFamily: 'sf',
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 4),
                                          //* Product Description
                                          Text(
                                            widget.productData
                                                .data()["description"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'sf',
                                                fontSize: 14,
                                                height: 1.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xffc5c5c5),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  productDescriptionModal(
                                      context, widget.productData);
                                },
                              ),
                              SizedBox(height: 5),
                              Divider(
                                height: 25,
                                thickness: 1.4,
                                color: Color(0XFFF3F3F3),
                              ),
                              //* Similar Products Section ------------------------------------------------------------
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* Similar Products Topic
                              Text(
                                "Similar Products",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4),
                              similarProductsList(
                                  context: context,
                                  category: widget.category,
                                  color: widget.productData
                                      .data()["product-details"]["color"],
                                  clothingStyle: widget.productData
                                          .data()["product-details"]
                                      ["clothing_style"],
                                  productId: widget.productData.id),
                              // SizedBox(height: 5),
                              Divider(
                                height: 25,
                                thickness: 1.4,
                                color: Color(0XFFF3F3F3),
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
          ),
        ],
      ),
    );
  }
}