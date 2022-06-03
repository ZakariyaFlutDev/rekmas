import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rekmas/Admin/adminLogin.dart';
import 'package:rekmas/Store/serviceHome.dart';
import 'package:rekmas/Store/serviceStore.dart';
import 'package:rekmas/Widgets/customTextField.dart';
import 'package:rekmas/DialogBox/errorDialog.dart';
import 'package:rekmas/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:rekmas/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/login.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login to your account",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                      controller: _emailTextEditingController,
                      data: Icons.email,
                      hintText: "Email",
                      isObscure: false),
                  CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock,
                      hintText: "Password",
                      isObscure: true),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // _uploadAndSaveImage();
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                              message: "Please write email and password");
                        });
              },
              child: Container(
                color: Colors.pink,
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminSignInPage())),
                icon: Icon(
                  Icons.nature_people,
                  color: Colors.pink,
                ),
                label: Text(
                  "i'm Admin",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "Authenticating, Please wait....");
        });

    FirebaseAuth _auth = FirebaseAuth.instance;
    User? firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if(firebaseUser != null){
      readData(firebaseUser!).then((s){
        Navigator.pop(context);
        // Route route  = MaterialPageRoute(builder: (c) => StoreHome());
        Route route  = MaterialPageRoute(builder: (c) => ServiceStore());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUser) async{
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then((dataSnapshot) async{

      print(dataSnapshot.get(EcommerceApp.userUID));
      await EcommerceApp.sharedPreferences!.setString("uid",dataSnapshot.get(EcommerceApp.userUID));

      await EcommerceApp.sharedPreferences!.setString(EcommerceApp.userEmail, dataSnapshot.get(EcommerceApp.userEmail));

      await EcommerceApp.sharedPreferences!.setString(EcommerceApp.userName, dataSnapshot.get(EcommerceApp.userName));

      await EcommerceApp.sharedPreferences!.setString(EcommerceApp.userAvatarUrl, dataSnapshot.get(EcommerceApp.userAvatarUrl));

      List<String> cartList = dataSnapshot.get(EcommerceApp.userCartList).cast<String>();
      await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userCartList, cartList);

      List<String> serviceList = dataSnapshot.get(EcommerceApp.userServiceList).cast<String>();
      await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userServiceList, serviceList);

      List<String> productQuantityList = dataSnapshot.get(EcommerceApp.productQuantities).cast<String>();
      await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.productQuantities, productQuantityList);
    });
  }
}
