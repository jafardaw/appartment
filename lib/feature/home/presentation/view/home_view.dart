import 'package:appartment/core/style/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      Center(child: Text('assasa')),
      Center(child: Text('assasa')),
      Center(child: Text('assasa')),
      Center(child: Text('assasa')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        color: Palette.primary,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),

        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 0 ? Palette.primary : Colors.white,
          ),
          Icon(
            Icons.receipt_long,
            size: 30,
            color: _selectedIndex == 1 ? Palette.primary : Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: _selectedIndex == 2 ? Palette.primary : Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: _selectedIndex == 3 ? Palette.primary : Colors.white,
          ),
        ],

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        letIndexChange: (index) => true,
      ),
    );
  }
}
