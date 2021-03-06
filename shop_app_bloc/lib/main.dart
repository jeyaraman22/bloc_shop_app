import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/bloc/intro_bloc/intro_screen_bloc.dart';
import 'package:shop_app_bloc/bloc/intro_bloc/intro_screen_bloc_event.dart';
import 'package:shop_app_bloc/screens/intro_screen.dart';

import 'bloc/banner_bloc/banner_bloc.dart';
import 'bloc/banner_bloc/banner_events.dart';
import 'bloc/product_bloc/add_product_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
import 'bloc/product_bloc/recent_product_bloc.dart';
import 'bloc/product_bloc/product_events.dart';
import 'repository/banner_repo/banner_repo.dart';
import 'repository/product_repo/product_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:[
      BlocProvider(create: (context)=> IntroScreenBloc()..add(InitiateIntroScreenEvent())),/// Here the intro_screen event initiated..
      BlocProvider(create: (_)=>BannerBloc(bannerRepo: BannerRepo())..add(LoadBanners())),///Banner Image Event initiated here..
      BlocProvider(create: (_)=>RecentProductBloc(productRepo: ProductRepo())..add(LoadRecentProductEvents())),///Get recent product event initiated here..
      BlocProvider(create: (_)=>ProductBloc(productRepo: ProductRepo())..add(LoadProductEvents())),
      // BlocProvider(create: (_)=>AddProductBloc(productRepo: ProductRepo())..add(LoadAddProductEvent()))///Get all product events initiated here..
      ], child:const MaterialApp(
      home: AppIntroScreen(),
    ));

  }
}
