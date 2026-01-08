import 'dart:math';
import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

class LoadingViewWidget extends StatelessWidget {
  final Color? color;
  final double? size;

  const LoadingViewWidget({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Palette.primary;
    final loadingSize = size ?? 55.0;

    return _PulseDotsLoading(color: primaryColor, size: loadingSize);
  }
}

class _PulseDotsLoading extends StatefulWidget {
  final Color color;
  final double size;

  const _PulseDotsLoading({required this.color, required this.size});

  @override
  __PulseDotsLoadingState createState() => __PulseDotsLoadingState();
}

class __PulseDotsLoadingState extends State<_PulseDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ScaleTransition(
            scale: DelayTween(
              begin: 0.3,
              end: 1.0,
              delay: index * 0.2,
            ).animate(_controller),
            child: Container(
              width: widget.size / 4,
              height: widget.size / 4,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, required this.delay})
    : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * 3.14) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}





///////////////
///// استخدام الصورة الافتراضية (أيقونة التسوق)
// LoadingViewWidget(type: LoadingType.imageShake)

// // استخدام صورة مخصصة مع الاهتزاز
// LoadingViewWidget(
//   type: LoadingType.imageShake,
//   imagePath: 'assets/images/logo.png', // مسار صورتك
//   size: 120, // حجم الصورة
//   color: Colors.blue, // اللون
// )

// // استخدام النقاط النابضة فقط (كما في السابق)
// LoadingViewWidget(type: LoadingType.pulseDots)