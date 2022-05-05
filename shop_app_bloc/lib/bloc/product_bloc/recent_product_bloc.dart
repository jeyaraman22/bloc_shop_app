import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/bloc/product_bloc/product_state.dart';
import 'package:shop_app_bloc/repository/product_repo/product_repo.dart';

import 'product_events.dart';

class RecentProductBloc extends Bloc<ProductEvents, ProductState> {
  final ProductRepo _productRepo;
  RecentProductBloc({required ProductRepo productRepo})
      : _productRepo = productRepo,
        super(RecentProductLoadingState()){
    on<LoadRecentProductEvents>((event, emit) async {
      emit(RecentProductLoadingState());
      final product=await _productRepo.getRecentProducts();///It get the reponse from firestore(holds recently added 10 items)
      // print("product length"+product.length.toString());
      emit(RecentProductLoadedState(product: product));
    });

  }

}