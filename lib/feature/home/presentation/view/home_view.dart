import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/theme/manger/theme_cubit.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/appartment_view.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/favorit_view.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:appartment/feature/home/presentation/view/SettingsView.dart';
import 'package:appartment/feature/myBooking/presentation/view/my_bookings_view.dart';

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
      AppartmentView(),
      FavoritesView(),
      MyBookingsView(),
      SettingsView(),
      // Center(
      //   child: IconButton(
      //     icon: Icon(
      //       context.read<ThemeCubit>().state == ThemeMode.light
      //           ? Icons.dark_mode
      //           : Icons.light_mode,
      //     ),
      //     onPressed: () {
      //       context.read<ThemeCubit>().toggleTheme();
      //     },
      //   ),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ApartmentsCubit(HomeRepo(ApiService())),
        ),
      ],
      child: Scaffold(
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
              Icons.favorite,
              size: 30,
              color: _selectedIndex == 1 ? Palette.primary : Colors.white,
            ),
            Icon(
              Icons.lock_clock_outlined,
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
      ),
    );
  }
}
