import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<int?> cartQuantity = ValueNotifier<int?>(0);

class CartItems {
  //* Add cart items to share preferences --------------------------------------------------------------
  addCartProducts({itemData, quantity}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //* Add first item to list
    if (prefs.getString('cartItems') == null) {
      List productDataList = [itemData];
      String encodedProductData = json.encode(productDataList); //* Encode List to String

      await prefs.setString('cartItems', encodedProductData);

      //* count total quantity
      await prefs.setInt('cartItemQuantity', quantity);
      cartQuantity.value = quantity;

      //* Adding items from 2nd onwards to the list
    } else {
      bool similarProduct = false;
      List productDataList = await jsonDecode(prefs.getString('cartItems') as String);

      //* Add similar products quantity only
      for (var i = 0; i < productDataList.length; i++) {
        if (productDataList[i][0] == itemData[0] && productDataList[i][3] == itemData[3]) {
          productDataList[i][2] = productDataList[i][2] + itemData[2];
          similarProduct = true;
          break;
        }
      }

      if (!similarProduct) {
        productDataList.add(itemData);
      }

      productDataList.sort((a, b) => a[1].compareTo(b[1])); //* Sort according to store order

      String encodedProductData = json.encode(productDataList); //* Encode List to String
      await prefs.setString('cartItems', encodedProductData);

      //* Add to total quantity
      int totalQuantity = prefs.getInt('cartItemQuantity')! + quantity as int;
      cartQuantity.value = totalQuantity;
      await prefs.setInt('cartItemQuantity', totalQuantity);
    }
  }

  //* Get cart item list from shared preferences
  getCartProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedProductData = prefs.getString('cartItems')!;
    List productDataList = json.decode(encodedProductData);
    List<Map<String, dynamic>> productFullDetails = [];
    int totalQuantity = 0;
    bool dataChanged = false;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //* Get a list of future operations
    final List<Future<DocumentSnapshot>> documentSnapshotFutureList = productDataList
        .map((productData) =>
            firestore.collection('products').doc(productData[4]).collection(productData[4]).doc(productData[0]).get())
        .toList();

    //* Get data from all the async operations
    final List<dynamic> documentSnapshotList = await Future.wait(documentSnapshotFutureList);

    //* Add product DocumentSnapshot to map
    productFullDetails = documentSnapshotList.map((documentSnapshot) => {'productDoc': documentSnapshot}).toList();

    for (var i = 0; i < productDataList.length; i++) {
      //* Add quantity and other data to the map
      productFullDetails[i]['selectedSize'] = productDataList[i][3];
      productFullDetails[i]['category'] = productDataList[i][4];
      productFullDetails[i]['productId'] = productDataList[i][0];

      //* Get size index according to documentSnapshot
      int? sizeIndex =
          productFullDetails[i]['productDoc'].data()['size']['size'].indexOf(productFullDetails[i]['selectedSize']);

      //* Get max stocks available
      int? maxQuantity = productFullDetails[i]['productDoc'].data()['size']['qty'][sizeIndex];

      //* If selected quantity is higher than max stocks available, it fix here
      if (productDataList[i][2]! > maxQuantity) {
        productFullDetails[i]['selectedQuantity'] = maxQuantity;

        //* Add to total quantity
        totalQuantity = prefs.getInt('cartItemQuantity')! - (productDataList[i][2] - maxQuantity) as int;
        cartQuantity.value = totalQuantity;
        productDataList[i][2] = maxQuantity;
        dataChanged = true;
      } else {
        productFullDetails[i]['selectedQuantity'] = productDataList[i][2];
      }
    }

    //* Update shared preferences if data have changed
    if (dataChanged) {
      encodedProductData = json.encode(productDataList); //* Encode List to String
      await prefs.setString('cartItems', encodedProductData);
      await prefs.setInt('cartItemQuantity', totalQuantity);
    }

    return productFullDetails;
  }

  //* Update changes of the cart to shared preferences
  updateCart({itemIndex, quantity, quantityDiff}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List productDataList = await jsonDecode(prefs.getString('cartItems') as String);

    if (quantityDiff != null) {
      //* Add quantity difference
      productDataList[itemIndex][2] += quantityDiff;

      //* Encode List to String
      String encodedProductData = json.encode(productDataList);
      await prefs.setString('cartItems', encodedProductData);

      //* Add to total quantity
      int totalQuantity = prefs.getInt('cartItemQuantity')! + quantityDiff as int;
      cartQuantity.value = totalQuantity;
      await prefs.setInt('cartItemQuantity', totalQuantity);
    } else {
      //* remove product from cart
      int totalQuantity = prefs.getInt('cartItemQuantity')! - (productDataList[itemIndex][2]) as int;
      cartQuantity.value = totalQuantity;
      await prefs.setInt('cartItemQuantity', totalQuantity);

      productDataList.removeAt(itemIndex);

      String encodedProductData = json.encode(productDataList);
      await prefs.setString('cartItems', encodedProductData);
    }
  }

  //* Get number of items in cart ------------------------------------------------------------------------
  getCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalQuantity = prefs.getInt('cartItemQuantity');
    return totalQuantity;
  }

  //* Delete share preferences data --------------------------------------------------------------------
  removeCartData() async {
    // Map m = {
    //   '1': ['2', 33],
    //   '2': ['32', 55]
    // };
    // var c = 0;
    // m.values.forEach((item) => c += item[1]);
    // print(c);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    await prefs.remove('cartItemQuantity');
  }
}
