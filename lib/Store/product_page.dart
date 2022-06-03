import 'package:rekmas/Widgets/customAppBar.dart';
import 'package:rekmas/Widgets/myDrawer.dart';
import 'package:rekmas/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:rekmas/Store/storehome.dart';


class ProductPage extends StatefulWidget {

  ProductPage({required this.itemModel});

  ItemModel itemModel;

  @override
  _ProductPageState createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {

  int? quantityOfItems;

  @override
  void initState() {
    super.initState();
    quantityOfItems = widget.itemModel.quantity == null ? 0 : widget.itemModel.quantity;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Center(
                          child: Image.network(widget.itemModel.thumbnailUrl
                              .toString(), fit: BoxFit.cover, width: double
                              .infinity,),
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade300,
                        child: SizedBox(height: 1.0, width: double.infinity,),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(widget.itemModel.title.toString(),
                              style: boldTextStyle),

                          SizedBox(height: 10.0,),

                          Text(widget.itemModel.longDescription.toString(),),

                          SizedBox(height: 10.0,),

                          Text("\$" + widget.itemModel.price.toString(),
                              style: boldTextStyle),

                          SizedBox(height: 10.0,),

                          Row(
                            children: [
                              IconButton(onPressed: () {
                                setState(() {
                                  quantityOfItems = quantityOfItems !- 1;
                                  print(quantityOfItems);
                                });
                              },
                                  icon: Icon(Icons.arrow_back_ios, size: 16,)
                              ),
                              Text( quantityOfItems.toString()),
                              IconButton(onPressed: () {
                                setState(() {
                                  quantityOfItems = quantityOfItems !+ 1;
                                  print(quantityOfItems);
                                });
                              },
                                  icon: Icon(Icons.navigate_next, size: 16,)
                              ),
                            ],
                          ),

                          SizedBox(height: 10.0,),

                        ],
                      ),

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () =>
                            checkItemInCart(widget.itemModel.shortInfo
                                .toString(),  context),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.pink,
                                    Colors.lightGreenAccent
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp
                              )
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart",
                              style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
