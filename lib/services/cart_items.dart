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

  //* Get cart item list from shared preferences
  getCartItemsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedItemData = prefs.getString('cartItems');
    Map<String, dynamic> itemDataMap = json.decode(encodedItemData);
    var sortedItemData = Map.fromEntries(itemDataMap.entries.toList()
      ..sort((a, b) =>
          a.value[6].toLowerCase().compareTo(b.value[6].toLowerCase())));
    return sortedItemData;
  }

  //* Update changes of the cart to shared preferences
  updateCart({itemDataMap, quantity, quantityDiff}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedItemData = json.encode(itemDataMap);
    await prefs.setString('cartItems', encodedItemData);
    if (quantity != null) {
      cartQuantity.value -= quantity;
      await prefs.setInt('cartItemQuantity', cartQuantity.value);
    } else {
      cartQuantity.value += quantityDiff;
      await prefs.setInt('cartItemQuantity', cartQuantity.value);
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
