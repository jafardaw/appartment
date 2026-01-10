import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/theme/manger/theme_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/appartment_view.dart';
import 'package:appartment/feature/desplayappartment/presentation/view/favorit_view.dart';
import 'package:appartment/feature/home/presentation/view/SettingsView.dart';
import 'package:appartment/feature/myBooking/presentation/view/my_bookings_view.dart';
import 'package:appartment/feature/ownerBo/presentation/view/OwnerBookingsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool isOwner = false; // القيمة الافتراضية
  bool isLoading = true; // حالة تحميل البيانات من الشيرد
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');

    setState(() {
      isOwner = role == 'owner';
      // ننشئ الصفحات بعد التأكد من الـ role
      _pages = [
        const AppartmentView(),
        const FavoritesView(),
        isOwner ? const OwnerBookingsView() : const MyBookingsView(),
        const SettingsView(),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم ينتهِ التحميل من الشيرد بريفرنس، نعرض مؤشر تحميل
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _pages[_selectedIndex],
          bottomNavigationBar: CurvedNavigationBar(
            index: _selectedIndex,
            height: 60,
            color: isDark
                ? const Color(0xFF1E1E1E)
                : const Color.fromARGB(255, 164, 134, 124),
            buttonBackgroundColor: isDark
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            items: [
              _navIcon(context, Icons.home, 0, isDark),
              _navIcon(context, Icons.favorite, 1, isDark),
              // أيقونة متغيرة: حقيبة عمل للمالك، أو تقويم للمستأجر
              _navIcon(
                context,
                isOwner
                    ? Icons.business_center_rounded
                    : Icons.calendar_month_rounded,
                2,
                isDark,
              ),
              _navIcon(context, Icons.settings, 3, isDark),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, int index, bool isDark) {
    return Icon(
      icon,
      size: 30,
      color: _selectedIndex == index
          ? Palette.primary
          : (isDark ? Colors.grey[400] : Colors.white),
    );
  }
}
