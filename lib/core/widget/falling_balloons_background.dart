import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FallingBalloonsBackground extends StatelessWidget {
  final int count;

  const FallingBalloonsBackground({super.key, this.count = 15});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(count, (index) => const _SingleBalloon()),
    );
  }
}

class _SingleBalloon extends StatefulWidget {
  const _SingleBalloon();

  @override
  State<_SingleBalloon> createState() => _SingleBalloonState();
}

class _SingleBalloonState extends State<_SingleBalloon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _startX;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _startX = Random().nextDouble();
    _color = [
      Colors.pink[100]!,
      Colors.yellow[100]!,
      Colors.green[100]!,
      Colors.white.withOpacity(0.4)
    ][Random().nextInt(4)];

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6 + Random().nextInt(4)),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: (_controller.value * 1.2 * MediaQuery.of(context).size.height) - 100,
          left: _startX * MediaQuery.of(context).size.width,
          child: Container(
            width: 35.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}