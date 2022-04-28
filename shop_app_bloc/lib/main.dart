import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/bloc/intro_bloc/intro_screen_bloc.dart';
import 'package:shop_app_bloc/bloc/intro_bloc/intro_screen_bloc_event.dart';
import 'package:shop_app_bloc/screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:[
      BlocProvider(create: (context)=> IntroScreenBloc()..add(InitiateIntroScreenEvent())),   /// Here the intro_screen event initiated..
    ], child:MaterialApp(
      home: AppIntroScreen(),
    ));

  }
}
