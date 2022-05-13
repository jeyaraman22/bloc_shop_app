import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? name;
  int? offerPrice;
  int? price;
  String? productImg;
  String? timestamp;

  ProductModel(
      {this.name,
        this.offerPrice,
        this.price,
        this.productImg,
        this.timestamp});

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    offerPrice = json['offer_price'];
    price = json['price'];
    productImg = json['product_img'];
    timestamp = json['timestamp'];
  }
  static ProductModel fromSnapshot(DocumentSnapshot snap){
    // print(snap['name']);
    ProductModel productModel=ProductModel(
      name: snap['name'],
      offerPrice: snap['offer_price'],
      price: snap['price'],
      productImg: snap['product_img'],
    );
    return productModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['offer_price'] = offerPrice;
    data['price'] = price;
    data['product_img'] = productImg;
    data['timestamp'] = timestamp;
    return data;
  }
}


