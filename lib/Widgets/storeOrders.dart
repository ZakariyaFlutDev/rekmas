import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Config/config.dart';
import 'loadingWidget.dart';
import 'orderCard.dart';

class StoreOrders extends StatefulWidget {
  const StoreOrders({Key? key}) : super(key: key);

  @override
  State<StoreOrders> createState() => _StoreOrdersState();
}

class _StoreOrdersState extends State<StoreOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
          !.collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
          !.getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("items").where(
                      "shortInfo",
                      whereIn: snapshot.data!.docs[index].get(EcommerceApp.productID)).get(),

                  //tepadegi yozuv aslida shunaqa edi
                  //whereIn: snapshot.data!.docs[index].data[EcommerceApp.productID]).get(),

                  builder: (c, snap) {
                    return snap.hasData
                        ? OrderCard(
                        itemCount: snap.data!.docs.length, data: snap.data!.docs, orderID: snapshot.data!.docs[index].id)
                        : Center(child: circularProgress(),);
                  },
                );
              },
            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
