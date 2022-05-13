import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_model.dart';
import '../../repository/cart_repo/cart_repo.dart';
import 'cart_events.dart';
import 'cart_state.dart';


class CartBloc extends Bloc<CartEvents, CartState> {
  final CartRepo _cartRepo;

  CartBloc({required CartRepo cartRepo})
      : _cartRepo = cartRepo,
        super(CartLoadingState()) {
    on<LoadCartEvents>((event, emit) async {
      // print("inside cart loading");
      emit(CartLoadingState());
      final product = await _cartRepo.getAllCartItems();///It get all the product details(name,price,offer_price,Image) from firestore..

      // print("Mycart length" + product.length.toString());
      emit(CartLoadedState(product: product));
    });
    on<UpdateAddCartEvent>((event, emit)async{
      emit(AddToCartLoadingState());
      // print("inside events"+event.name);
      ProductModel(name: event.name,offerPrice: event.offerprice,price: event.price,productImg: event.productImg);
      // print(ProductModel().toJson());
      await _cartRepo.addCartItem(event.name,event.offerprice,event.price,event.productImg);///The value of new products(name,price,offer_price,Image) send to firestore..
      emit(AddToCartLoadedState());
      emit(CartLoadingState());
      final product = await _cartRepo.getAllCartItems();///It get all the product details(name,price,offer_price,Image) from firestore..

      // print("Mycart length" + product.length.toString());
      emit(CartLoadedState(product: product));

    });
    on<CartDeletetLoadedEvent>((event, emit) async {
      emit(CartDeleteItemLoadingState());
      await _cartRepo.deleteCartItem(event.name);
      emit(CartDeleteItemLoadedState());
    });

  }
}