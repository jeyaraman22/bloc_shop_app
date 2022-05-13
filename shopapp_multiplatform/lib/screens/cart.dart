import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_events.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../bloc/cart_bloc/cartcount_bloc.dart';
import '../utils/dynamicheigthwidth.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}


class _MyCartState extends State<MyCart> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("triggered");
    context.read<CartBloc>().add(LoadCartEvents());
    context.read<CartCountBloc>().add(CartCountIncrementEvent());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My cart"),
          centerTitle: true,
        ),
        body: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if(state is CartDeleteItemLoadedState){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Product deleted Successfully")));
              context.read<CartBloc>().add(LoadCartEvents());

            }
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoadingState) {
                return SizedBox(
                    width: getDevicewidth(context, 1),
                    height: getDeviceheight(context, 1),
                    child: const Center(child: CircularProgressIndicator()));
              }
              if (state is CartLoadedState) {
                return Card(
                  semanticContainer: true,
                  margin: const EdgeInsets.all(2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ListView.builder(
                    itemCount: state.product.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        semanticContainer: true,
                        margin: const EdgeInsets.all(2),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: NetworkImage(state.product[index].productImg!),
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: getDeviceheight(context, 0.01),
                                ),
                                Text(state.product[index].name!),
                                SizedBox(
                                  height: getDeviceheight(context, 0.01),
                                ),
                                Text("Price: "+state.product[index].price.toString(),
                                    style: const TextStyle(
                                        decoration:
                                            TextDecoration.lineThrough)),
                                SizedBox(
                                  height: getDeviceheight(context, 0.01),
                                ),
                                Text("Offer Price: "+state.product[index].offerPrice.toString()),
                              ],
                            ),
                            //
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(CartDeletetLoadedEvent(name: state.product[index].name!));
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 30,
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Text("Something went wrong");
              }
            },
          ),
        ));
  }
}
