import 'dart:async';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/feature/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // بدء تأثير ظهور النصوص
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // الانتقال بعد 4 ثوانٍ (زدناها قليلاً ليعطي وقتاً للقراءة)
    _navigationTimer = Timer(const Duration(seconds: 4), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.assetsImagesPhoto20250924144805RemovebgPreview,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // إضافة طبقة تعتيم خفيفة لجعل النص أوضح
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مرحباً بك',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'راحتكم هي غايتنا.. نعدكم بخدمة تليق بكم',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black87,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // خط بسيط للزينة
                  SizedBox(
                    width: 50,
                    child: Divider(color: Colors.white, thickness: 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
