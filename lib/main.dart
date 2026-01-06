import 'package:appartment/feature/auth/splash_view.dart';
import 'package:flutter/material.dart';

// لدعم اللغات والـ RTL

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'appartment System',

      // يمكن لاحقاً وضع BlocProvider هنا إذا كنت تريد تمرير الـ Cubit
      home: const SplashScreen(),
    );
  }
}
