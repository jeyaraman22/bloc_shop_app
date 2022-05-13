
import '../../model/product_model.dart';

abstract class BaseCartRepo{
  Future<List<ProductModel>> getAllCartItems();
  Future<void> addCartItem(String name,int offerprice,int price,String productimg);
  Future<void> deleteCartItem(String name);
}