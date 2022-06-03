import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rekmas/Admin/adminOrderDetails.dart';
import 'package:rekmas/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:rekmas/Widgets/orderCard.dart';

import '../Store/storehome.dart';


  int counter=0;

class AdminOrderCard extends StatelessWidget
{

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCard({Key? key, required this.itemCount, required this.data, required this.orderID, required this.addressID, required this.orderBy});

  @override
  Widget build(BuildContext context)
  {
    return  InkWell(
      onTap: (){
        Route? route;
        if(counter == 0){
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => AdminOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID, ));
        }
        Navigator.pushReplacement(context, route!);
      },
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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index){
            ItemModel model = ItemModel.fromJson(data[index].data() as Map<String, dynamic>);
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );;
  }
}
