import 'package:cloud_firestore/cloud_firestore.dart';

class CartCalculations {
  //* Get total price of cart producta
  int getTotal({required cartItemsList, required totalPrice}) {
    if (cartItemsList != null)
      cartItemsList!.forEach(
        (element) {
          totalPrice += (((element['productDoc'].data()['discount'] != 0)
                      ? (element['productDoc'].data()['price'] *
                          ((100 - element['productDoc'].data()['discount']) / 100))
                      : (element['productDoc'].data()['price'])) *
                  element['selectedQuantity'])
              .round() as int;
        },
      );

    return totalPrice;
  }

  //* Get shipping price -----------------------------------------------------------------
  getShipping({required List cartItemsList, required String userId}) async {
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot? ds2;
    DocumentSnapshot userDoc;
    Map userLocation;
    List totalWeight = [];
    List storeLocation = [];
    List shippingPrice = [];
    int fixedWeightPrice = 50;
    int storeCount = 0;

    // Stopwatch stopwatch = new Stopwatch()..start();

    //* Get user details
    // userId = await AuthService().getUser();

    //* Get user shipping details
    userDoc = await firestore.collection('users').doc(userId).get();
    userLocation = (((userDoc.data() as Map)['shipping']) != null)
        ? (userDoc.data() as Map)['shipping']
        : {'province': 'Western', 'district': 'Colombo', 'city': 'Nugegoda'}; //* Add Nugegoda as default

    //*Get shipping price
    ds2 = await firestore
        .collection('shipping')
        .doc(userLocation['province'])
        .collection(userLocation['province'])
        .doc(userLocation['district'])
        .collection(userLocation['district'])
        .doc(userLocation['city'])
        .get();

    //* Get a list of future operations
    final List<Future<DocumentSnapshot>> documentSnapshotFutureList = cartItemsList
        .map((cartItem) => firestore.collection('stores').doc(cartItem['productDoc'].data()['store-id']).get())
        .toList();

    //* Get data from all the async operations
    final List<dynamic> documentSnapshotList = await Future.wait(documentSnapshotFutureList);

    for (var i = 0; i < cartItemsList.length; i++) {
      totalWeight.insert(
          i,
          double.parse((cartItemsList[i]['productDoc'].data()['weight'] * cartItemsList[i]['selectedQuantity']!)
              .toStringAsFixed(2)));

      //* Get number of different stores
      if (i == 0 ||
          cartItemsList[i]['productDoc'].data()['store-name'] !=
              cartItemsList[i - 1]['productDoc'].data()['store-name']) {
        storeCount++;
        storeLocation.add((documentSnapshotList[i].data() as Map)['location']); //* Add store locations
      }
    }

    //* Calculate the shipping prices
    int i = 0;
    for (var c = 0; c < storeCount; c++) {
      double storeWeight = 0;
      int productsPerStore = 1;
      storeWeight = totalWeight[i];

      //* Get sum of products in one store
      while (cartItemsList.length - 1 > i &&
          cartItemsList[i]['productDoc'].data()['store-name'] ==
              cartItemsList[i + 1]['productDoc'].data()['store-name']) {
        storeWeight += totalWeight[i + 1];
        i++;
        productsPerStore++;
      }
      //* Add shipping prices to the array
      shippingPrice.add(((ds2.data() as Map)[storeLocation[c]]) + ((storeWeight.ceil() - 1) * fixedWeightPrice));
      for (var x = 1; x < productsPerStore; x++) {
        shippingPrice.add(0);
      }
      i++;
    }

    // print('getShipping() executed in ${stopwatch.elapsed}');
    return [shippingPrice, userLocation];
  }
}
