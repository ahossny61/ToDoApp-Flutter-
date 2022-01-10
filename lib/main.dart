import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layout/home_layout.dart';
import 'package:todoapp/shared/bloc_observer.dart';

void main() {
  Bloc.observer=MyBlocObserver();
  MyApp app=MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:HomeLayout()
    );

  }

}
