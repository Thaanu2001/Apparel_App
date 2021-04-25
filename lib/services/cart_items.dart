import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

ValueNotifier<int> cartQuantity = ValueNotifier<int>(0);

class CartItems {
  //* Add cart items to share preferences --------------------------------------------------------------
  cartItems({itemData, quantity}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cartItems') == null) {
      //* Add first item to map
      Map<String, dynamic> itemDataMap = {'1': itemData};
      String encodedItemData = json.encode(itemDataMap);
      await prefs.setString('cartItems', encodedItemData);
      await prefs.setInt('cartItemQuantity', quantity);
      cartQuantity.value = quantity;
    } else {
      //* Adding items from 2nd onwards to the map
      String encodedItemData = prefs.getString('cartItems');
      Map<String, dynamic> itemDataMap = json.decode(encodedItemData);
      int mapLength = itemDataMap.length;
      itemDataMap[(mapLength + 1).toString()] = itemData;
      encodedItemData = json.encode(itemDataMap);
      await prefs.setString('cartItems', encodedItemData);

      int totalQuantity = prefs.getInt('cartItemQuantity');
      totalQuantity += quantity;
      await prefs.setInt('cartItemQuantity', totalQuantity);
      cartQuantity.value = totalQuantity;

      print(encodedItemData);
      print(mapLength);
      print(totalQuantity);
    }
  }

  //* Get number of items in cart ------------------------------------------------------------------------
  getCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalQuantity = prefs.getInt('cartItemQuantity');
    return totalQuantity;
  }

  //* Delete share preferences data --------------------------------------------------------------------
  removeCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    await prefs.remove('cartItemQuantity');
  }
}
