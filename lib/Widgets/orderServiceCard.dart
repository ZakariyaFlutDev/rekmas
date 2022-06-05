
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/item.dart';
import '../Orders/OrderDetailsPage.dart';
int counter = 0;
class OrderServiceCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderServiceCard({Key? key, required this.itemCount, required this.data, required this.orderID});


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Route? route;
        if(counter == 0){
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID ));
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
            print("Index $index");
            print("Data ${data[index].data().toString()}");
            ServiceModel model = ServiceModel.fromJson(data[index].data() as Map<String, dynamic>);
            return sourceOrderServiceInfo(model, context);
          },
        ),
      ),
    );
  }
}



Widget sourceOrderServiceInfo(ServiceModel model, BuildContext context,
    {Color? background})
{
  var width =  MediaQuery.of(context).size.width;

  return  Container(
    color: Colors.grey.shade100,
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl.toString(),
          width: 100.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        model.orderName.toString(),
                        style:
                        TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        model.serviceHeight.toString(),
                        style: TextStyle(
                            color: Colors.black54, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(
                          children: [
                            Text(
                              r"Total Price: ",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                            Text(
                              r"$",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.red),
                            ),
                            Text(
                              model.totalPrice.toString(),
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),

              Flexible(
                child: Container(),
              ),

              //to implement the cart item remove//add feature

              Divider(
                height: 5.0,
                color: Colors.pink,
              )
            ],
          ),
        )
      ],
    ),
  );
}
