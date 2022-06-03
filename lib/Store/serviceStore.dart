import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekmas/Store/serviceHome.dart';
import 'package:rekmas/Store/storehome.dart';

import '../Config/config.dart';
import '../Counters/cartitemcounter.dart';
import '../Widgets/myDrawer.dart';
import 'cart.dart';
class ServiceStore extends StatefulWidget {
  const ServiceStore({Key? key}) : super(key: key);

  @override
  State<ServiceStore> createState() => _ServiceStoreState();
}

class _ServiceStoreState extends State<ServiceStore> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Store",
                ),
                Tab(
                  text: "Service",
                )
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 5,
              labelStyle: TextStyle(fontSize: 18),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pink, Colors.lightGreenAccent],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp)),
            ),
            title: Text(
              "Reklama Master",
              style: TextStyle(
                  fontSize: 55, color: Colors.white, fontFamily: "Signatra"),
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      Route route =
                      MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.pink,
                        ),
                        Positioned(
                          top: 3.0,
                          bottom: 4.0,
                          left: 6.0,
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                              int cnt = (EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList)!.length-1) + (EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userServiceList)!.length-1);
                              return Text(
                                cnt.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          drawer: MyDrawer(),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.lightGreenAccent
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
            ),
            child: TabBarView(
              children: [
                StoreHome(),
                ServiceHome()
              ],
            ),
          ),
        )
    );
  }
}
