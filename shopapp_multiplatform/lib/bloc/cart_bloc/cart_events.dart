import 'package:equatable/equatable.dart';

import '../../model/product_model.dart';


abstract class CartEvents extends Equatable{
  const CartEvents();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadCartEvents extends CartEvents{}

class UpdateCartEvents extends CartEvents{
  final List<ProductModel> products;

  const UpdateCartEvents(this.products);

  @override
  // TODO: implement props
  List<Object?> get props => [products];
}

class LoadAddCartEvent extends CartEvents{}

class UpdateAddCartEvent extends CartEvents{
  final String name;
  final int offerprice;
  final int price;
  final String productImg;
  const UpdateAddCartEvent({
    required this.name,
    required this.offerprice,
    required this.price,
    required this.productImg,
  });

  @override
  // TODO: implement props
  List<Object?> get props {  return [name,offerprice,price,productImg];}


}
class CartCountLoadingEvent extends CartEvents{}
class CartCountIncrementEvent extends CartEvents{}

class CartDeletetLoadingEvent extends CartEvents{}
class CartDeletetLoadedEvent extends CartEvents{
  final String name;
  CartDeletetLoadedEvent({required this.name});
  @override
  // TODO: implement props
  List<Object?> get props => [name];
}