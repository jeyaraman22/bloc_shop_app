import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/product_model.dart';
import 'base_cart_item_repo.dart';


class CartRepo extends BaseCartRepo{
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late QuerySnapshot querySnapshot;
  List<ProductModel> data=[];
  @override
  Future<void> addCartItem(String name, int offerprice, int price, String productimg) async {
    try{
      final snapshot=await _firebaseFirestore.collection("cart").doc(name).get();
      if(snapshot.exists){
        print("data exist");
      }else{
        await _firebaseFirestore
            .collection("cart")
            .add({'name':name,'offer_price':offerprice,'price':price,'product_img':productimg,'timestamp':FieldValue.serverTimestamp()});
      }

    }catch(e){
      print(e);
    }
  }

  @override
  Future<List<ProductModel>> getAllCartItems() async {
    querySnapshot = await _firebaseFirestore.collection('cart').get();

    data=querySnapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    return data;
  }

  @override
  Future<void> deleteCartItem(String name) async{
    try{
      await _firebaseFirestore.collection("cart").doc();
    }catch(e){
      print(e);
    }
  }

}