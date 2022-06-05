import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Config/config.dart';
import '../Widgets/loadingWidget.dart';
import 'adminOrderCard.dart';
class AdminStoreOrders extends StatefulWidget {
  const AdminStoreOrders({Key? key}) : super(key: key);

  @override
  State<AdminStoreOrders> createState() => _AdminStoreOrdersState();
}

class _AdminStoreOrdersState extends State<AdminStoreOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("shortInfo",
                      whereIn: snapshot.data!.docs[index]
                          .get(EcommerceApp.productID))
                      .get(),

                  //tepadegi yozuv aslida shunaqa edi
                  //whereIn: snapshot.data!.docs[index].data[EcommerceApp.productID]).get(),

                  builder: (c, snap) {
                    return snap.hasData
                        ? AdminOrderCard(
                      itemCount: snap.data!.docs.length,
                      data: snap.data!.docs,
                      orderID: snapshot.data!.docs[index].id,
                      orderBy: snapshot.data!.docs[index].get("orderBy"),
                      addressID: snapshot.data!.docs[index].get("addressID"),
                    )
                        : Center(
                      child: circularProgress(),
                    );
                  },
                );
              },
            )
                : Center(
              child: circularProgress(),
            );
          },
        ),
      ),
    );
  }
}
