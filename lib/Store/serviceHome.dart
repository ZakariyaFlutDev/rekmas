import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rekmas/Widgets/loadingWidget.dart';

import '../Config/config.dart';
import '../Counters/cartitemcounter.dart';

class ServiceHome extends StatefulWidget {
  const ServiceHome({Key? key}) : super(key: key);

  @override
  State<ServiceHome> createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> with AutomaticKeepAliveClientMixin<ServiceHome> {
  File? _file;

  bool get wantKeepAlive => true;

  TextEditingController _widthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _orderNameController = TextEditingController();
  bool _isCalculate = false;
  bool _upLoading = false;
  String serviceId = DateTime.now().millisecondsSinceEpoch.toString();

  double? totalPrice;
  double _serviceWidth = 0.0;
  double _serviceHeight = 0.0;

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
        child: Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextField(
                  controller: _orderNameController,
                  decoration: InputDecoration(
                      hintText: "Buyurtma Nomi",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  color: Colors.grey.withOpacity(.6),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: _file == null
                      ? Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 100,
                          color: Colors.grey.shade200,
                        )
                      : Image.file(
                          _file!,
                          fit: BoxFit.cover,
                        ),
                ),
                onTap: () {
                  takeImage(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            controller: _widthController,
                            decoration: InputDecoration(
                                hintText: "Eni (metr)",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "X",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            controller: _heightController,
                            decoration: InputDecoration(
                                hintText: "Bo'yi (metr)",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                "1 kavadrat metri: 32 000 so'm",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              _isCalculate
                  ? Text(
                      "$_serviceWidth * $_serviceHeight * 32 000 = ${_serviceHeight * _serviceWidth * 32000} so'm",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 100),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent),
                  child: Center(
                    child: Text(
                      "Hisoblash",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                onTap: () {
                  print(_orderNameController.text);

                  print("Total Price: $totalPrice");
                  print(_serviceHeight);
                  print(_serviceWidth);

                  setState(() {
                    _heightController.text != null
                        ? _serviceHeight = double.parse(_heightController.text)
                        : _serviceHeight = 0.0;
                    _widthController.text != null
                        ? _serviceWidth = double.parse(_widthController.text)
                        : _serviceWidth = 0.0;
                    totalPrice = _serviceHeight * _serviceWidth * 32000;
                    _isCalculate = true;
                  });

                  print("Total Price: $totalPrice");
                },
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: _upLoading
                    ? null
                    : () {
                        checkServiceInCart(_orderNameController.text, context);
                        uploadImageAndSaveServiceInfo();
                      },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: Center(
                    child: Text(
                      "Buyurtma Berish",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        _upLoading
            ? Center(
                child: circularProgress(),
              )
            : SizedBox.shrink(),
      ],
    ));
  }

  uploadImageAndSaveServiceInfo() async {
    setState(() {
      _upLoading = true;
    });

    if (_file != null) {
      String imageDownloadUrl = await uploadServiceImage(_file!);

      saveServiceInfo(imageDownloadUrl);
    } else {
      saveServiceInfo("null");
    }
  }

  Future<String> uploadServiceImage(sFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Service");
    UploadTask uploadTask =
        storageReference.child("service_$serviceId.jpg").putFile(sFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveServiceInfo(String downloadUrl) {
    final servicesRef = FirebaseFirestore.instance.collection("services");
    servicesRef.doc(serviceId).set({
      "serviceWidth": double.parse(_widthController.text),
      "serviceHeight": double.parse(_heightController.text),
      "totalPrice": totalPrice,
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "orderName": _orderNameController.text,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item Added to Cart, Successfully.");

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    ;

    setState(() {
      _file = null;
      _upLoading = false;
      serviceId = DateTime.now().millisecondsSinceEpoch.toString();
      _widthController.clear();
      _heightController.clear();
      _orderNameController.clear();
      totalPrice = 0;
      _isCalculate = false;
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (c) {
          return SimpleDialog(
            title: Text(
              "Item Page",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );

    setState(() {
      _file = File(imageFile!.path);
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _file = File(imageFile!.path);
    });
  }
}

void checkServiceInCart(String orderName, BuildContext context) {
  EcommerceApp.sharedPreferences!
          .getStringList(EcommerceApp.userServiceList)!
          .contains(orderName)
      ? Fluttertoast.showToast(msg: "Service is already in Cart")
      : addServiceToCart(orderName, context);
}

addServiceToCart(String orderName, BuildContext context) {
  List<String> tempCartList = EcommerceApp.sharedPreferences!
      .getStringList(EcommerceApp.userServiceList)!
      .cast<String>();
  tempCartList.add(orderName);

  EcommerceApp.firestore!
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userServiceList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Service Added to Cart, Successfully.");
    EcommerceApp.sharedPreferences!
        .setStringList(EcommerceApp.userServiceList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
