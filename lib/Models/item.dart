import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String ? title;
  String ? shortInfo;
  Timestamp ? publishedDate;
  String ? thumbnailUrl;
  String ? longDescription;
  String ? status;
  int ? price;

  // add
  int? quantity;

  ItemModel(
      {this.title,
        this.shortInfo,
        this.publishedDate,
        this.thumbnailUrl,
        this.longDescription,
        this.status,
        this.price,
        this.quantity,
        });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    quantity = json['quantity'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['quantity'] = this.quantity;
    return data;
  }
}

class ServiceModel {
  double ? serviceWidth;
  double ? serviceHeight;
  Timestamp ? publishedDate;
  String ? thumbnailUrl;
  String ? orderName;
  String ? status;
  double ? totalPrice;

  // add
  int? quantity;

  ServiceModel(
      {this.serviceWidth,
        this.serviceHeight,
        this.publishedDate,
        this.thumbnailUrl,
        this.orderName,
        this.status,
        this.totalPrice,
      });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    serviceWidth = json["serviceWidth"];
    serviceHeight = json["serviceHeight"];
    totalPrice = json["totalPrice"];
    publishedDate = json["publishedDate"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
    orderName = json["orderName"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceWidth'] = this.serviceWidth;
    data['serviceHeight'] = this.serviceHeight;
    data['totalPrice'] = this.totalPrice;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['orderName'] = this.orderName;
    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  String ? date;

  PublishedDate({required this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
