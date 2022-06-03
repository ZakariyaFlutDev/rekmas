import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rekmas/Config/config.dart';
import 'package:rekmas/Orders//placeOrderPayment.dart';
import 'package:rekmas/Widgets/customAppBar.dart';
import 'package:rekmas/Widgets/loadingWidget.dart';
import 'package:rekmas/Widgets/wideButton.dart';
import 'package:rekmas/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/address.dart';
import 'addAddress.dart';

class Address extends StatefulWidget {
  const Address({Key? key, required this.totalAmount}) : super(key: key);
  final double? totalAmount;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Address"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.add_location),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore!
                      .collection(EcommerceApp.collectionUser)
                      .doc(EcommerceApp.sharedPreferences!
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data!.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                      model: AddressModel.fromJson(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>),
                                      currentIndex: address.count,
                                      addressId: snapshot.data!.docs[index].id
                                          .toString(),
                                      totalAmount:
                                          widget.totalAmount!.toDouble(),
                                      value: index);
                                },
                              );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        width: double.infinity,
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            Text("No shipment address has been saved"),
            Text(
                "Please add your shipment Address so that we can deliver product")
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  AddressCard(
      {Key? key,
      required this.model,
      required this.currentIndex,
      required this.addressId,
      required this.totalAmount,
      required this.value})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: widget.value,
                    groupValue: widget.currentIndex,
                    activeColor: Colors.pink,
                    onChanged: (val) {
                      //Shu yerda nimadir bo'ladi.
                      //Objectni avval string qilding keyin int. Xato bo'lishi mumkin

                      if (val is int) {
                        Provider.of<AddressChanger>(context, listen: false)
                            .displayResult(val);
                      }
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            KeyText(
                              msg: "Name",
                            ),
                            Text(widget.model.name.toString())
                          ]),
                          TableRow(children: [
                            KeyText(msg: "Phone Number"),
                            Text(widget.model.phoneNumber.toString()),
                          ]),
                          TableRow(children: [
                            KeyText(msg: "Flat Number"),
                            Text(widget.model.flatNumber.toString()),
                          ]),
                          TableRow(children: [
                            KeyText(msg: "City"),
                            Text(widget.model.city.toString()),
                          ]),
                          TableRow(children: [
                            KeyText(msg: "State"),
                            Text(widget.model.state.toString()),
                          ]),
                          TableRow(children: [
                            KeyText(msg: "Pin Code"),
                            Text(widget.model.pincode.toString()),
                          ]),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Route route = MaterialPageRoute(
                            builder: (c) => PaymentPage(
                                  addressId: widget.addressId,
                                  totalAmount: widget.totalAmount,
                                ));
                        Navigator.push(context, route);
                      });
                    },
                  )
                : Container(

                  )
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
