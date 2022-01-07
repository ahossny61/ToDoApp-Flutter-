import 'package:flutter/material.dart';
import 'package:todoapp/layout/home_layout.dart';

void main() {
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
