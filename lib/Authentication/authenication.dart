import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:rekmas/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.lightGreenAccent
                  ],
                    begin: FractionalOffset(0.0,0.0),
                    end: FractionalOffset(1.0,0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp
                )
              ),
            ),
            title: Text("Reklama Master", style: TextStyle(fontSize: 55, color: Colors.white, fontFamily: "Signatra"),),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color: Colors.white,),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(Icons.person, color: Colors.white,),
                  text: "Registe",
                )
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 5,
            ),
          ),
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
                Login(),
                Register()
              ],
            ),
          ),
        )
    );
  }
}
