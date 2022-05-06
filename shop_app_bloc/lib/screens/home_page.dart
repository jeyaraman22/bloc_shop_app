import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/bloc/banner_bloc/banner_bloc.dart';
import 'package:shop_app_bloc/bloc/banner_bloc/banner_state.dart';
import 'package:shop_app_bloc/bloc/product_bloc/product_bloc.dart';
import 'package:shop_app_bloc/bloc/product_bloc/recent_product_bloc.dart';
import 'package:shop_app_bloc/bloc/product_bloc/product_events.dart';
import 'package:shop_app_bloc/bloc/product_bloc/product_state.dart';
import 'package:shop_app_bloc/utils/dynamicheigthwidth.dart';
import 'package:shop_app_bloc/widgets/carousel_sliders.dart';

import '../bloc/banner_bloc/banner_events.dart';
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Banner images Blocbuilder
            BlocBuilder<BannerBloc, BannerState>(builder: (context, state) {
              if (state is BannerLoading) {
                return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/4,child: Center(child: CircularProgressIndicator()));
              }
              if (state is BannerLoaded) {
                print("loaded");
                images = state.banners.map((e) => e.imageUrl).toList();
                return Container(
                  color: Colors.white,
                  width: getDevicewidth(context, 1),
                  child: Stack(
                    children: [
                      ///Carosel Slider Component invoked from widget
                      CaroselSlider(
                        indexValue: count,
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
                  height: getDeviceheight(context, 0.2),
                  child: ListView.builder(
                    itemCount: state.product.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: getDevicewidth(context, 0.25),
                        height: getDeviceheight(context, 0.145),
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
                                width: getDevicewidth(context, 0.25),
                                height: getDeviceheight(context, 0.13),
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
            BlocListener<ProductBloc, ProductState>(
              listener:(context,state) {
                if(state is AddProductNavigationState){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddNewProduct()));
                  context.read<ProductBloc>().add(AddProductWidgetEvent());
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                if (state is ProductLoadingState) {
                  return SizedBox(width:getDevicewidth(context, 1),height:getDeviceheight(context, 1)/3,child: const Center(child: CircularProgressIndicator()));
                }
                if (state is ProductLoadedState) {
                  print("all product length"+state.product.length.toString());
                  return SizedBox(
                    width: getDevicewidth(context, 1),
                    child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            /// crossAxisCount is the number of columns
                            crossAxisCount: 2,
                            /// This creates two columns with two items in each column
                            children: List.generate(state.product.length, (indexs) {
                              print(getDevicewidth(context, 1));
                              print(getDeviceheight(context, 1));

                              return Card(
                                margin: const EdgeInsets.all(2),
                                child: Column(
                                  children: [
                                    Image(
                                      image: NetworkImage(state.product[indexs].productImg!),
                                      width: getDevicewidth(context, 0.45),
                                      height: getDeviceheight(context, 0.19),
                                      fit: BoxFit.fill,
                                    ),
                                    Text(state.product[indexs].name!),
                                    Text("Price: "+state.product[indexs].price.toString(),
                                        style: const TextStyle(decoration: TextDecoration.lineThrough)),
                                    Text("Offer Price: "+state.product[indexs].offerPrice.toString())
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
