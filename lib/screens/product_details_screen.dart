import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Apparel_App/screens/image_zoom_screen.dart';
import 'package:Apparel_App/screens/purchase_screen.dart';
import 'package:Apparel_App/services/customicons_icons.dart';
import 'package:Apparel_App/widgets/other_products_list.dart';
import 'package:Apparel_App/widgets/product_description_modal.dart';
import 'package:Apparel_App/widgets/product_details_modal.dart';
import 'package:Apparel_App/widgets/scroll_glow_disabler.dart';
import 'package:Apparel_App/widgets/seller_card.dart';
import 'package:Apparel_App/widgets/similar_products_list.dart';
import 'package:Apparel_App/widgets/shopping_cart_button.dart';
import 'package:Apparel_App/screens/auth/sign_in_screen.dart';
import 'package:Apparel_App/transitions/slide_top_transition.dart';

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
  List imageList = imgList;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _current = 0;

  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  var similarProducts;
  var otherProducts;
  var sellerCard;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();

    //* Similar products list
    similarProducts = similarProductsList(
        context: context,
        category: widget.category,
        color: widget.productData.data()["product-details"]["color"],
        clothingStyle: widget.productData.data()["product-details"]
            ["clothing-style"],
        productId: widget.productData.id);

    //* Seller Data Card
    sellerCard = storeCard(widget.productData.data()["store-id"]);

    //* Seller's other products list
    otherProducts = otherProductsList(
        context: context,
        category: widget.category,
        storeId: widget.productData.data()["store-id"],
        productId: widget.productData.id);
  }

  //* Image list for slider -------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imageList
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
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      drawerScrimColor: Colors.transparent,
      //* Floating shopping cart button ---------------------------------------------------------------------------
      floatingActionButton: ShoppingCartButton(),
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
                        Customicons.bag,
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
                        Customicons.settings,
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
            padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 15),
                //* Back icon ---------------------------------------------------------------------------
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 32,
                      color: Color(0xff646464),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 20),
                //* Home Icon -----------------------------------------------------------------------------
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    child: Icon(
                      Customicons.home_1_,
                      size: 26,
                      color: Color(0xff646464),
                    ),
                    onTap: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
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
                controller: _scrollController,
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    child: Hero(
                      placeholderBuilder: (_scrollPosition >=
                              MediaQuery.of(context).size.width * 0.5)
                          ? (context, heroSize, child) {
                              return Opacity(opacity: 1, child: child);
                            }
                          : (context, heroSize, child) {
                              return Opacity(opacity: 0, child: child);
                            },
                      transitionOnUserGestures: true,
                      flightShuttleBuilder:
                          (context, anim, direction, fromContext, toContext) {
                        final Hero toHero = toContext.widget;
                        if (direction == HeroFlightDirection.pop &&
                            _scrollController.position.pixels >=
                                MediaQuery.of(context).size.width * 0.5) {
                          print(_scrollController.position.pixels);
                          print(MediaQuery.of(context).size.width * 0.5);
                          return FadeTransition(
                            opacity: AlwaysStoppedAnimation(0),
                            child: toHero.child,
                          );
                        } else {
                          return toHero.child;
                        }
                      },
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
                                  children: imageList.map((url) {
                                    int index = imageList.indexOf(url);
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
                                thickness: 1.6,
                                color: Color(0XFFE3E3E3),
                              ),
                              //* Product Details ----------------------------------------------------------------------
                              InkWell(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    //* Brand Title
                                                    Text(
                                                      "Brand",
                                                      style: TextStyle(
                                                          fontFamily: 'sf',
                                                          fontSize: 14,
                                                          height: 1.4,
                                                          color:
                                                              Color(0xff808080),
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
                                                          color:
                                                              Color(0xff808080),
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
                                                          color:
                                                              Color(0xff808080),
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
                                                              "product-details"]
                                                          ["brand"],
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
                                                              "product-details"]
                                                          ["type"],
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
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xffc5c5c5),
                                      size: 20,
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
                                thickness: 1.6,
                                color: Color(0XFFE3E3E3),
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
                                thickness: 1.6,
                                color: Color(0XFFE3E3E3),
                              ),
                              //* Buy Now button -------------------------------------------------------------------
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
                                  onPressed: () async {
                                    if (FirebaseAuth
                                            .instance.currentUser?.uid ==
                                        null) {
                                      Route route = SlideTopTransition(
                                        widget: SignInScreen(
                                          route: SlideTopTransition(
                                            widget: PurchaseScreen(
                                              productData: widget.productData,
                                              isBuyNow: true,
                                              category: widget.category,
                                            ),
                                          ),
                                        ),
                                      );
                                      Navigator.push(context, route);
                                    } else {
                                      Route route = SlideTopTransition(
                                        widget: PurchaseScreen(
                                          productData: widget.productData,
                                          isBuyNow: true,
                                          category: widget.category,
                                        ),
                                      );
                                      Navigator.push(context, route);
                                    }
                                  },
                                  child: Text(
                                    "Buy Now",
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              //* Add to cart button -------------------------------------------------------------------
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.black, width: 2)),
                                    primary: Colors.grey,
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (FirebaseAuth
                                            .instance.currentUser?.uid ==
                                        null) {
                                      Route route = SlideTopTransition(
                                        widget: SignInScreen(
                                          route: SlideTopTransition(
                                            widget: PurchaseScreen(
                                              productData: widget.productData,
                                              isBuyNow: false,
                                              category: widget.category,
                                            ),
                                          ),
                                        ),
                                      );
                                      Navigator.push(context, route);
                                    } else {
                                      Route route = SlideTopTransition(
                                        widget: PurchaseScreen(
                                          productData: widget.productData,
                                          isBuyNow: false,
                                          category: widget.category,
                                        ),
                                      );
                                      Navigator.push(context, route);
                                    }
                                  },
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                        fontFamily: 'sf',
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 25,
                                thickness: 1.6,
                                color: Color(0XFFE3E3E3),
                              ),
                            ],
                          ),
                        ),
                        //* Similar Products Section ------------------------------------------------------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Similar Products Topic
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                "Similar Products",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: 4),
                            //* Similar products list
                            similarProducts,
                            Divider(
                              height: 25,
                              thickness: 1.6,
                              color: Color(0XFFE3E3E3),
                            ),
                          ],
                        ),
                        //* About the Seller Section ------------------------------------------------------------
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* About the Seller Topic
                              Text(
                                "About the Seller",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4),
                              //* About the Seller Card
                              sellerCard,
                              Divider(
                                height: 25,
                                thickness: 1.6,
                                color: Color(0XFFE3E3E3),
                              ),
                            ],
                          ),
                        ),
                        //* Seller's other products Section ------------------------------------------------------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Other Products Topic
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                "Seller's Other Products",
                                style: TextStyle(
                                    fontFamily: 'sf',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: 4),
                            //* Other products list
                            otherProducts,
                            SizedBox(height: 10)
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
    );
  }
}
