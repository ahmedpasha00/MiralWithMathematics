import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

class CommonGameBackground extends StatelessWidget {
  final Widget child; // هذا هو المحتوى الذي سيظهر فوق الخلفية والثلج

  const CommonGameBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. الخلفية الثابتة
        Image.asset(
          "assets/images/backgroind.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // 2. طبقة التلج (Snowfall)
        const SnowFallAnimation(
          config: SnowfallConfig(
            numberOfSnowflakes: 80, // عدد متوازن للأداء
            speed: 1.0,
            useEmoji: true,
            customEmojis: ['❄️', '❅', '❆'],
            enableRandomOpacity: true,
          ),
        ),

        // 3. المحتوى المتغير (الأزرار أو اللعبة)
        child,
      ],
    );
  }
}