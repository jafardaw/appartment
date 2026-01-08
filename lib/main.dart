import 'package:appartment/core/theme/manger/theme_cubit.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/auth/splash_view.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/booking_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/favorit_cubit.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // استيراد المكتبة
// لدعم اللغات والـ RTL

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BookingCubit(HomeRepo(ApiService()))),
        BlocProvider(create: (context) => FavoritesCubit()),

        BlocProvider(create: (_) => ThemeCubit()),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            themeMode: themeMode,
            // الثيم الفاتح
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // الثيم الداكن
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blueGrey,

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            locale: const Locale('ar', 'AE'), // اللغة الافتراضية للتطبيق
            supportedLocales: const [
              Locale('ar', 'AE'), // العربية
              Locale('en', 'US'), // الإنجليزية
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'appartment System',

            // يمكن لاحقاً وضع BlocProvider هنا إذا كنت تريد تمرير الـ Cubit
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
