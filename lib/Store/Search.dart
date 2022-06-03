import 'package:rekmas/Models/item.dart';
import 'package:rekmas/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rekmas/Widgets/loadingWidget.dart';

import '../Widgets/customAppBar.dart';


class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}


class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot>? docList;


  Future startSearching(String query) async {
    docList = FirebaseFirestore.instance.collection("items").where(
        "shortInfo", isGreaterThanOrEqualTo: query).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(bottom: PreferredSize(
        child: searchWidget(), preferredSize: Size(56.0, 56.0),),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: docList,
        builder: (context, snap) {
          print(snap.data);
          print(snap.error);
          return snap.hasData
              ? ListView.builder(
              itemCount: snap.data!.docs.length,
            itemBuilder: (context, index){
                ItemModel model = ItemModel.fromJson(snap.data!.docs[index].data() as Map<String, dynamic>);

                return sourceInfo(model, context);
            },
          )
              : Center(child: circularProgress(),);
        },
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 80.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
          )
      ),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 40,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.blueGrey,),
            ),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      print(value);
                      startSearching(value);
                    },
                    decoration: InputDecoration.collapsed(
                        hintText: "Search here..."),
                  ),
                )
            )
          ],
        ),
      ),

    );
  }

}
