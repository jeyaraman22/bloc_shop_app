import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_bloc/model/product_model.dart';
import 'package:shop_app_bloc/repository/product_repo/base_product_repo.dart';

class ProductRepo extends FetchProductRepo{
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late QuerySnapshot querySnapshot;
  List<ProductModel> data=[];
  @override
  Future<List<ProductModel>> getAllProducts() async {
    querySnapshot = await _firebaseFirestore.collection('products').get();
    data=querySnapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

    return data;
  }

  @override
  Future<void> addProducts(String name,int offerprice,int price,String productimg) async{
    try{
      await _firebaseFirestore.collection("products").add({'name':name,'offer_price':offerprice,'price':price,'product_img':productimg,'timestamp':FieldValue.serverTimestamp()});
    }catch(e){
      print(e);
    }
  }

  @override
  Future<List<ProductModel>> getRecentProducts() async {
    querySnapshot = await _firebaseFirestore.collection('products').orderBy('timestamp',descending: true).limit(10).get();
    print(querySnapshot.docs.first.data());
    data=querySnapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    print(data.length);
    return data;
  }



}