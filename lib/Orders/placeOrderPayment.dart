import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rekmas/Config/config.dart';
import 'package:rekmas/Store/storehome.dart';
import 'package:rekmas/Counters/cartitemcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekmas/main.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key? key, required this.addressId, required this.totalAmount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("images/cash.png"),
            ),
            SizedBox(height: 10.0,),
            FlatButton(
              color: Colors.pinkAccent,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.deepOrange,
              onPressed: () => addOrderDetails(),
              child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
            )
          ],
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(
          EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!.getStringList(
          EcommerceApp.userCartList),

      EcommerceApp.serviceID: EcommerceApp.sharedPreferences!.getStringList(
          EcommerceApp.userServiceList),

      EcommerceApp.productQuantities: EcommerceApp.sharedPreferences!.getStringList(
          EcommerceApp.productQuantities),

      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      EcommerceApp.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences!.getString(
          EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!.getStringList(
          EcommerceApp.userCartList),
      EcommerceApp.serviceID: EcommerceApp.sharedPreferences!.getStringList(
          EcommerceApp.userServiceList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() =>
    {
      emptyCartNow(),
    });
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences!.setStringList(
        EcommerceApp.userCartList, ["garbageValue"]);
    List<String>? tempList = EcommerceApp.sharedPreferences!.getStringList(
        EcommerceApp.userCartList);

    EcommerceApp.sharedPreferences!.setStringList(
        EcommerceApp.userServiceList, ["garbageValue"]);
    List<String>? tempServiceList = EcommerceApp.sharedPreferences!.getStringList(
        EcommerceApp.userServiceList);

    EcommerceApp.sharedPreferences!.setStringList(
        EcommerceApp.productQuantities, ["garbageValue"]);
    List<String>? quantityList = EcommerceApp.sharedPreferences!.getStringList(
        EcommerceApp.productQuantities);

    FirebaseFirestore.instance.collection("users").doc(
        EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)).update(
        {
          EcommerceApp.userCartList: tempList,
          EcommerceApp.userServiceList: tempServiceList,
          EcommerceApp.productQuantities: quantityList,
        }).then((value) {
      EcommerceApp.sharedPreferences!.setStringList(
          EcommerceApp.userCartList, tempList!);

      EcommerceApp.sharedPreferences!.setStringList(
          EcommerceApp.userServiceList, tempServiceList!);

      EcommerceApp.sharedPreferences!.setStringList(
          EcommerceApp.productQuantities, quantityList!);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(
        msg: "Congiratulation, your Order has been placed successfully.");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore!
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)! +
        data["orderTime"])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore!
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)! +
        data["orderTime"])
        .set(data);
  }
}
