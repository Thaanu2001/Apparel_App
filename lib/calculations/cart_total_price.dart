class CartCalculations {
  //* Get total price of cart producta
  int getTotal({required cartItemsList, required totalPrice}) {
    if (cartItemsList != null)
      cartItemsList!.forEach(
        (element) {
          totalPrice += (((element['productDoc'].data()['discount'] != 0)
                      ? (element['productDoc'].data()['price'] *
                          ((100 - element['productDoc'].data()['discount']) /
                              100))
                      : (element['productDoc'].data()['price'])) *
                  element['selectedQuantity'])
              .round() as int;
        },
      );

    return totalPrice;
  }
}
