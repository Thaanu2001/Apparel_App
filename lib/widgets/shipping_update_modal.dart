import 'package:Apparel_App/services/dismiss_keyboard.dart';
import 'package:Apparel_App/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

shippingUpdateModal(context, userId) {
  final fullName = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();

  String? selectedProvince;
  String? provinceId;
  String? selectedDistrict;
  String? districtId;
  String? selectedCity;
  bool errorVisible = false;
  bool scrollReverse = false;
  bool onProgress = false;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SingleChildScrollView(
              reverse: (MediaQuery.of(context).viewInsets.bottom == 0)
                  ? false
                  : scrollReverse,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                    //* Topic
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        "Edit Shipping Address",
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 15),
                    //* First Name textfield ---------------------------------------------------------
                    CustomTextField(
                      controller: fullName,
                      labelText: 'Full Name',
                      fillHint: AutofillHints.name,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      onTap: () => setState(() {
                        scrollReverse = false;
                      }),
                    ),
                    SizedBox(height: 15),
                    //* Mobile Number textfield ---------------------------------------------------------
                    CustomTextField(
                      controller: mobile,
                      labelText: 'Mobile Number',
                      fillHint: AutofillHints.telephoneNumber,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.phone,
                      onTap: () => setState(() {
                        scrollReverse = false;
                      }),
                    ),
                    SizedBox(height: 15),
                    //* Province Selecting Dropdown ----------------------------------------------------
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('shipping')
                          .orderBy('province')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 12, top: 0, bottom: 0, right: 8),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'sf',
                              fontSize: 18,
                            ),
                            filled: false,
                            labelText: 'Province',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: new BorderSide(
                                  color: Colors.black, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          focusColor: Colors.black,
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.black,
                          isDense: true,
                          items: (snapshot.hasData)
                              ? snapshot.data!.docs.map((DocumentSnapshot doc) {
                                  return new DropdownMenuItem<String>(
                                    value: doc['province'],
                                    child: Text(
                                      doc['province'],
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onTap: () {
                                      provinceId = doc.id;
                                      selectedDistrict = null;
                                      districtId = null;
                                    },
                                  );
                                }).toList()
                              : [
                                  DropdownMenuItem(
                                    child: Text(
                                      'Loading...',
                                      style: TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                          value: selectedProvince,
                          onChanged: (dynamic value) {
                            selectedProvince = value;
                            setState(() {});
                            print('$provinceId $selectedProvince');
                          },
                          onTap: () => dismissKeyboard(context),
                        );
                      },
                    ),
                    if (provinceId != null) SizedBox(height: 15),
                    //* District Selecting Dropdown ----------------------------------------------------
                    if (provinceId != null)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('shipping')
                            .doc(provinceId)
                            .collection(selectedProvince as String)
                            .orderBy('district')
                            .snapshots(),
                        builder: (context, snapshot) {
                          return DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 12, top: 0, bottom: 0, right: 8),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'sf',
                                fontSize: 18,
                              ),
                              filled: false,
                              labelText: 'District',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: new BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            focusColor: Colors.black,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            isDense: true,
                            items: (snapshot.hasData)
                                ? snapshot.data!.docs
                                    .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem<String>(
                                      value: doc['district'],
                                      child: Text(
                                        doc['district'],
                                        style: TextStyle(
                                            fontFamily: 'sf',
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onTap: () {
                                        districtId = doc.id;
                                        selectedCity = null;
                                      },
                                    );
                                  }).toList()
                                : [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontFamily: 'sf',
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                            value: selectedDistrict,
                            // key: _key,
                            onChanged: (dynamic value) {
                              selectedDistrict = value;
                              setState(() {});
                              print('$districtId $selectedDistrict');
                            },
                            onTap: () => dismissKeyboard(context),
                          );
                        },
                      ),
                    if (districtId != null) SizedBox(height: 15),
                    //* City Selecting Dropdown ----------------------------------------------------
                    if (districtId != null)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('shipping')
                            .doc(provinceId)
                            .collection(selectedProvince as String)
                            .doc(districtId)
                            .collection(selectedDistrict as String)
                            .orderBy('city')
                            .snapshots(),
                        builder: (context, snapshot) {
                          return DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 12, top: 0, bottom: 0, right: 8),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'sf',
                                fontSize: 18,
                              ),
                              filled: false,
                              labelText: 'City',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: new BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            focusColor: Colors.black,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            isDense: true,
                            items: (snapshot.hasData)
                                ? snapshot.data!.docs
                                    .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem<String>(
                                      value: doc['city'],
                                      child: Text(
                                        doc['city'],
                                        style: TextStyle(
                                            fontFamily: 'sf',
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    DropdownMenuItem(
                                      child: Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontFamily: 'sf',
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                            value: selectedCity,
                            // key: _key,
                            onChanged: (dynamic value) {
                              selectedCity = value;
                              setState(() {});
                            },
                            onTap: () => dismissKeyboard(context),
                          );
                        },
                      ),
                    if (selectedCity != null) SizedBox(height: 15),
                    if (selectedCity != null)
                      //* Address Textfield ----------------------------------------------------
                      CustomTextField(
                        controller: address,
                        labelText: 'Address',
                        fillHint: AutofillHints.fullStreetAddress,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        onTap: () => setState(() {
                          scrollReverse = true;
                        }),
                      ),
                    (errorVisible)
                        ? Container(
                            //* Error message Text -------------------------------------------------------------------------------
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Please enter all details correctly',
                              style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : SizedBox(height: 15),
                    //* Save address button -------------------------------------------------------------------
                    // if (address.text != '')
                    if (address.text != '')
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
                          child: (!onProgress)
                              ? Text(
                                  "Save Address",
                                  style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                ),
                          //* Button on press function
                          onPressed: () async {
                            if (!onProgress) {
                              if (fullName.text != '' &&
                                  mobile.text != '' &&
                                  address.text != '') {
                                setState(() {
                                  errorVisible = false;
                                  onProgress = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .update({
                                      'shipping': {
                                        'name': fullName.text,
                                        'mobile': mobile.text,
                                        'province': selectedProvince,
                                        'district': selectedDistrict,
                                        'city': selectedCity,
                                        'address': address.text,
                                      }
                                    })
                                    .then((value) => Navigator.pop(context))
                                    .catchError((error) =>
                                        print("Failed to update user: $error"));
                              } else {
                                setState(() {
                                  errorVisible = true;
                                });
                              }
                              setState(() {
                                onProgress = false;
                              });
                            }
                            // inProgress = true;
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}
