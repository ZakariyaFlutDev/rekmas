import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Config/config.dart';
import 'loadingWidget.dart';
import 'orderServiceCard.dart';

class ServiceOrders extends StatefulWidget {
  const ServiceOrders({Key? key}) : super(key: key);

  @override
  State<ServiceOrders> createState() => _ServiceOrdersState();
}

class _ServiceOrdersState extends State<ServiceOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore!
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences!
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("services")
                            .where("orderName",
                                whereIn: snapshot.data!.docs[index]
                                    .get(EcommerceApp.serviceID))
                            .get(),

                        //tepadegi yozuv aslida shunaqa edi
                        //whereIn: snapshot.data!.docs[index].data[EcommerceApp.productID]).get(),

                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderServiceCard(
                                  itemCount: snap.data!.docs.length,
                                  data: snap.data!.docs,
                                  orderID: snapshot.data!.docs[index].id)
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
