import 'package:flutter/material.dart';
import 'package:poc1/screen/line_screen.dart';
import 'package:poc1/screen/audio_screen.dart';

class TypeTabBarScreen extends StatefulWidget {
  const TypeTabBarScreen({super.key});

  @override
  State<TypeTabBarScreen> createState() => _TypeTabBarScreenState();
}

class _TypeTabBarScreenState extends State<TypeTabBarScreen>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _controller,
              tabs: const [
                Tab(text: 'Line',),
                Tab(text: 'Audio'),
              ],
              labelStyle: TextStyle(fontSize: 18),
              labelColor: Color(0xff00bbd2),
              unselectedLabelColor: Colors.white,
              indicatorColor: Color(0xff00bbd2),
              dividerColor: Colors.transparent,
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: const [
                  LineScreen(),
                  AudioScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}