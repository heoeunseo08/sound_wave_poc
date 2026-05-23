import 'package:flutter/material.dart';
import 'package:poc1/screen/type_tab_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TypeTabBarScreen(),
    );
  }
}