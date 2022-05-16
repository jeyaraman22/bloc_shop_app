import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp_multiplatform/firebase_options.dart';



import '../bloc/banner_bloc/banner_bloc.dart';
import '../bloc/banner_bloc/banner_events.dart';
import '../bloc/banner_bloc/banner_state.dart';
import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_events.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../bloc/cart_bloc/cartcount_bloc.dart';
import '../bloc/product_bloc/product_bloc.dart';
import '../bloc/product_bloc/product_events.dart';
import '../bloc/product_bloc/product_state.dart';
import '../bloc/product_bloc/recent_product_bloc.dart';
import '../utils/dynamicheigthwidth.dart';
import '../widgets/carousel_sliders.dart';
import 'add_product.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
GlobalKey<CarouselSliderState> keys = GlobalKey();

class _HomePageState extends State<HomePage> {
  int count = 0;
  List images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("homepager");
    context.read<CartCountBloc>().add(CartCountIncrementEvent());

  }

  @override
  Widget build(BuildContext context) {
    print(getDevicewidth(context, 1));
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home Page"),
        actions:[IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            context.read<ProductBloc>().add(AddProductNavigationEvents(context: context));///Navigation event is triggered here..
          },
        )],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ((getDevicewidth(context, 1)<600))?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Banner images Blocbuilder
            BlocBuilder<BannerBloc, BannerState>(builder: (context, state) {
              if (state is BannerLoading) {
                context.read<CartCountBloc>().add(CartCountIncrementEvent());
                return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is BannerLoaded) {
                print("loaded");
                images = state.banners.map((e) => e.imageUrl).toList();
                return Container(
                  color: Colors.white,
                  width: getDevicewidth(context, 1),
                  height: getDeviceheight(context, 0.30),
                  child: Stack(
                    children: [
                      ///Carosel Slider Component invoked from widget
                      CaroselSlider(
                        indexValue: count,
                        caroselheight: getDeviceheight(context, 0.30),
                        images: images,
                        enlargecenterimage: false,
                        imageslideduration: 3,
                        infinitescroll: true,
                        sliderautoplay: true,
                        viewportfraction: 0.9,
                        buttoncontroller: true,
                        onCountChanged: (int val) {
                          // context.read<BannerBloc>().add(PageIncrementEvent(val));
                          //print (count);
                        },
                        controller: (val) {
                          keys = val;
                        },
                      ),
                      // Positioned(
                      //     right: 34,
                      //     top: 11,
                      //     child: Text(
                      //       (count+ 1).toString() +
                      //           "/" +
                      //           images.length.toString(),
                      //       style: TextStyle(color: Colors.grey[500]),
                      //     ))
                    ],
                  ),
                );
              } else {
                return Text("SomeThing error");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.013),),

            ///Recent Added products Blocbuilder
            const Text(
              "Recent Product",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            BlocBuilder<RecentProductBloc, ProductState>(builder: (context, state) {
              if (state is RecentProductLoadingState) {
                return Container(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is RecentProductLoadedState) {

                return Container(
                  padding: const EdgeInsets.all(2),
                  width: getDevicewidth(context, 1),
                  height: getDevicewidth(context, 1)<400?getDeviceheight(context, 0.20):getDeviceheight(context, 0.18),
                  child: ListView.builder(
                    itemCount: state.product.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: getDevicewidth(context, 0.22),
                        height: getDevicewidth(context, 1)<400?getDeviceheight(context, 0.20):getDeviceheight(context, 0.18),
                        child: Card(
                          shape: index==0
                              ?  RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)):RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                    state.product[index].productImg!),
                                width: getDevicewidth(context, 0.16),
                                height: getDeviceheight(context, 0.11),
                                fit: BoxFit.fitWidth,
                              ),
                              Text(state.product[index].name!),
                            ],
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                );
              }

              else {
                return const Text("Something went wrong");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.02),),
            ///Product Display Blocbuilder
            const Text(
              "All Products",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),

            MultiBlocListener(
              listeners: [
                BlocListener<ProductBloc, ProductState>(
                    listener:(context,state) {
                      if(state is AddProductNavigationState){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AddNewProduct()));
                        context.read<ProductBloc>().add(AddProductWidgetEvent());
                      }
                    }),
                BlocListener<CartBloc,CartState>(listener: (context, state) {
                  if( state is AddToCartLoadedState){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Product added to cart Successfully")));
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                  }
                  if(state is CartCountIncrementState){
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
                BlocListener<CartCountBloc,CartState>(listener: (context, state) {

                  if(state is CartCountIncrementState){
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
              ],
              child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                if (state is ProductLoadingState) {
                  return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/3,child: const Center(child: CircularProgressIndicator()));
                }
                if (state is ProductLoadedState) {
                  print("all product length"+state.product.length.toString());
                  return SizedBox(
                    // width: getDevicewidth(context, 1),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      /// crossAxisCount is the number of columns
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(2),
                      childAspectRatio:getDevicewidth(context, 1)<400?0.77: 0.73,
                      /// This creates two columns with two items in each column
                      children: List.generate(state.product.length, (indexs) {

                        return Card(
                          semanticContainer: true,
                          margin: const EdgeInsets.all(2),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(state.product[indexs].productImg!),
                                width: getDevicewidth(context, 0.40),
                                height: getDeviceheight(context, 0.20),
                                fit: BoxFit.fill,
                              ),
                              Text(state.product[indexs].name!),
                              Text("Price: "+state.product[indexs].price.toString(),
                                  style: const TextStyle(decoration: TextDecoration.lineThrough)),
                              Text("Offer Price: "+state.product[indexs].offerPrice.toString()),
                              RaisedButton(onPressed: (){
                                context.read<CartBloc>().add(UpdateAddCartEvent(name: state.product[indexs].name!,offerprice: state.product[indexs].offerPrice!,price: state.product[indexs].price!,productImg: state.product[indexs].productImg!));
                                context.read<CartBloc>().add(LoadCartEvents());
                              },

                                color: Colors.orangeAccent,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.add_card_outlined),Text("Add to cart")],),
                              )
                            ],
                          ),
                        );
                      }),
                    ),

                  );
                } else {
                  return const Text("Something went wrong");
                }
              }),
            ),

          ],
        ):((getDevicewidth(context, 1)>600) && (getDevicewidth(context, 1)<900))?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Banner images Blocbuilder
            BlocBuilder<BannerBloc, BannerState>(builder: (context, state) {
              if (state is BannerLoading) {
                context.read<CartCountBloc>().add(CartCountIncrementEvent());
                return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is BannerLoaded) {
                print("loaded");
                images = state.banners.map((e) => e.imageUrl).toList();
                return Container(
                  color: Colors.white,
                  width: getDevicewidth(context, 1),
                  height: getDeviceheight(context, 0.45),
                  child: Stack(
                    children: [
                      ///Carosel Slider Component invoked from widget
                      CaroselSlider(
                        indexValue: count,
                        caroselheight: getDeviceheight(context, 0.45),
                        images: images,
                        enlargecenterimage: false,
                        imageslideduration: 3,
                        infinitescroll: true,
                        sliderautoplay: true,
                        viewportfraction: 0.9,
                        buttoncontroller: true,
                        onCountChanged: (int val) {
                          // context.read<BannerBloc>().add(PageIncrementEvent(val));
                          //print (count);
                        },
                        controller: (val) {
                          keys = val;
                        },
                      ),
                      // Positioned(
                      //     right: 34,
                      //     top: 11,
                      //     child: Text(
                      //       (count+ 1).toString() +
                      //           "/" +
                      //           images.length.toString(),
                      //       style: TextStyle(color: Colors.grey[500]),
                      //     ))
                    ],
                  ),
                );
              } else {
                return Text("SomeThing error");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.013),),

            ///Recent Added products Blocbuilder
            const Text(
              "Recent Product",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            BlocBuilder<RecentProductBloc, ProductState>(builder: (context, state) {
              if (state is RecentProductLoadingState) {
                return Container(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is RecentProductLoadedState) {

                return Container(
                  padding: const EdgeInsets.all(2),
                  width: getDevicewidth(context, 1),
                  height: getDeviceheight(context, 0.3),
                  child: ListView.builder(
                    itemCount: state.product.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: getDevicewidth(context, 0.22),
                        height: getDeviceheight(context, 0.245),
                        child: Card(
                          shape: index==0
                              ?  RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)):RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                    state.product[index].productImg!),
                                width: getDevicewidth(context, 0.16),
                                height: getDeviceheight(context, 0.22),
                                fit: BoxFit.fitWidth,
                              ),
                              Text(state.product[index].name!),
                            ],
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                );
              }

              else {
                return const Text("Something went wrong");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.02),),
            ///Product Display Blocbuilder
            const Text(
              "All Products",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),

            MultiBlocListener(
              listeners: [
                BlocListener<ProductBloc, ProductState>(
                    listener:(context,state) {
                      if(state is AddProductNavigationState){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AddNewProduct()));
                        context.read<ProductBloc>().add(AddProductWidgetEvent());
                      }
                    }),
                BlocListener<CartBloc,CartState>(listener: (context, state) {
                  if( state is AddToCartLoadedState){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Product added to cart Successfully")));
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                  }
                  if(state is CartCountIncrementState){
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
                BlocListener<CartCountBloc,CartState>(listener: (context, state) {

                  if(state is CartCountIncrementState){
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
              ],
              child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                if (state is ProductLoadingState) {
                  return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/3,child: const Center(child: CircularProgressIndicator()));
                }
                if (state is ProductLoadedState) {
                  print("all product length"+state.product.length.toString());
                  return SizedBox(
                    // width: getDevicewidth(context, 1),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      /// crossAxisCount is the number of columns
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(2),
                      childAspectRatio: 1.1,
                      /// This creates two columns with two items in each column
                      children: List.generate(state.product.length, (indexs) {

                        return Card(
                          semanticContainer: true,
                          margin: const EdgeInsets.all(2),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(state.product[indexs].productImg!),
                                width: getDevicewidth(context, 0.42),
                                height: getDeviceheight(context, 0.42),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: getDeviceheight(context, 0.01),),
                              Text(state.product[indexs].name!),
                              SizedBox(height: getDeviceheight(context, 0.003),),
                              Text("Price: "+state.product[indexs].price.toString(),
                                  style: const TextStyle(decoration: TextDecoration.lineThrough)),
                              SizedBox(height: getDeviceheight(context, 0.003),),
                              Text("Offer Price: "+state.product[indexs].offerPrice.toString()),
                              SizedBox(height: getDeviceheight(context, 0.01),),
                              Container(
                                height: getDeviceheight(context, 0.07),
                                child: RaisedButton(onPressed: (){
                                  context.read<CartBloc>().add(UpdateAddCartEvent(name: state.product[indexs].name!,offerprice: state.product[indexs].offerPrice!,price: state.product[indexs].price!,productImg: state.product[indexs].productImg!));
                                  context.read<CartBloc>().add(LoadCartEvents());
                                },

                                  color: Colors.orangeAccent,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.add_card_outlined),Text("Add to cart")],),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),

                  );
                } else {
                  return const Text("Something went wrong");
                }
              }),
            ),

          ],
        ):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Banner images Blocbuilder
            BlocBuilder<BannerBloc, BannerState>(builder: (context, state) {
              if (state is BannerLoading) {
                context.read<CartCountBloc>().add(CartCountIncrementEvent());
                return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is BannerLoaded) {
                print("loaded");
                images = state.banners.map((e) => e.imageUrl).toList();
                return Container(
                  color: Colors.white,
                  width: getDevicewidth(context, 1),
                  height: getDeviceheight(context, 0.45),
                  child: Stack(
                    children: [
                      ///Carosel Slider Component invoked from widget
                      CaroselSlider(
                        indexValue: count,
                        caroselheight: getDeviceheight(context, 0.45),
                        images: images,
                        enlargecenterimage: false,
                        imageslideduration: 3,
                        infinitescroll: true,
                        sliderautoplay: true,
                        viewportfraction: 0.9,
                        buttoncontroller: true,
                        onCountChanged: (int val) {
                          // context.read<BannerBloc>().add(PageIncrementEvent(val));
                          //print (count);
                        },
                        controller: (val) {
                          keys = val;
                        },
                      ),
                      // Positioned(
                      //     right: 34,
                      //     top: 11,
                      //     child: Text(
                      //       (count+ 1).toString() +
                      //           "/" +
                      //           images.length.toString(),
                      //       style: TextStyle(color: Colors.grey[500]),
                      //     ))
                    ],
                  ),
                );
              } else {
                return Text("SomeThing error");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.013),),

            ///Recent Added products Blocbuilder
            const Text(
              "Recent Product",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            BlocBuilder<RecentProductBloc, ProductState>(builder: (context, state) {
              if (state is RecentProductLoadingState) {
                return Container(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is RecentProductLoadedState) {

                return Container(
                  padding: const EdgeInsets.all(2),
                  width: getDevicewidth(context, 1),
                  height: getDeviceheight(context, 0.3),
                  child: ListView.builder(
                    itemCount: state.product.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: getDevicewidth(context, 0.22),
                        height: getDeviceheight(context, 0.245),
                        child: Card(
                          shape: index==0
                              ?  RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)):RoundedRectangleBorder(
                              side:  const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                    state.product[index].productImg!),
                                width: getDevicewidth(context, 0.16),
                                height: getDeviceheight(context, 0.22),
                                fit: BoxFit.fitWidth,
                              ),
                              Text(state.product[index].name!),
                            ],
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                );
              }

              else {
                return const Text("Something went wrong");
              }
            }),
            SizedBox(height: getDeviceheight(context,0.02),),
            ///Product Display Blocbuilder
            const Text(
              "All Products",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),

            MultiBlocListener(
              listeners: [
                BlocListener<ProductBloc, ProductState>(
                    listener:(context,state) {
                      if(state is AddProductNavigationState){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AddNewProduct()));
                        context.read<ProductBloc>().add(AddProductWidgetEvent());
                      }
                    }),
                BlocListener<CartBloc,CartState>(listener: (context, state) {
                  if( state is AddToCartLoadedState){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Product added to cart Successfully")));
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                  }
                  if(state is CartCountIncrementState){
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
                BlocListener<CartCountBloc,CartState>(listener: (context, state) {

                  if(state is CartCountIncrementState){
                    context.read<CartCountBloc>().add(CartCountIncrementEvent());
                    print("CartCountIncrementState"+state.CartCount);

                  }
                }),
              ],
              child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                if (state is ProductLoadingState) {
                  return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/3,child: const Center(child: CircularProgressIndicator()));
                }
                if (state is ProductLoadedState) {
                  print("all product length"+state.product.length.toString());
                  return Container(
                    color: Colors.white70,
                    padding: EdgeInsets.fromLTRB(getDevicewidth(context, 0.05), 0, getDevicewidth(context, 0.05), 0),
                    // width: getDevicewidth(context, 1),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,

                      /// crossAxisCount is the number of columns
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(2),
                      childAspectRatio: 1.5,
                      /// This creates two columns with two items in each column
                      children: List.generate(state.product.length, (indexs) {

                        return Card(
                          semanticContainer: true,
                          margin: const EdgeInsets.all(2),
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(state.product[indexs].productImg!),
                                width: getDevicewidth(context, 0.30),
                                height: getDeviceheight(context, 0.32),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: getDeviceheight(context, 0.01),),
                              Text(state.product[indexs].name!),
                              SizedBox(height: getDeviceheight(context, 0.003),),
                              Text("Price: "+state.product[indexs].price.toString(),
                                  style: const TextStyle(decoration: TextDecoration.lineThrough)),
                              SizedBox(height: getDeviceheight(context, 0.003),),
                              Text("Offer Price: "+state.product[indexs].offerPrice.toString()),
                              SizedBox(height: getDeviceheight(context, 0.01),),
                              Container(
                                height: getDeviceheight(context, 0.07),
                                child: RaisedButton(onPressed: (){
                                  context.read<CartBloc>().add(UpdateAddCartEvent(name: state.product[indexs].name!,offerprice: state.product[indexs].offerPrice!,price: state.product[indexs].price!,productImg: state.product[indexs].productImg!));
                                  context.read<CartBloc>().add(LoadCartEvents());
                                },

                                  color: Colors.orangeAccent,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.add_card_outlined),Text("Add to cart")],),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),

                  );
                } else {
                  return const Text("Something went wrong");
                }
              }),
            ),

          ],
        ),
      ),
    );
  }
}
