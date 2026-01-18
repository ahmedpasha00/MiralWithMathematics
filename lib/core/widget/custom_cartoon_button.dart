import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCartoonButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final TextStyle? style; // ✨ ضفنا الستايل هنا كمتغير اختياري
  const CustomCartoonButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap, required MaterialAccentColor backgroundColor, this.style,
  });

  @override
  State<CustomCartoonButton> createState() => _CustomCartoonButtonState();
}

class _CustomCartoonButtonState extends State<CustomCartoonButton> with SingleTickerProviderStateMixin {
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          // جسم الزرار الـ 3D
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: widget.color, // التحكم في اللون من الخارج
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
              boxShadow: [
                // الظل السفلي الغامق للبروز
                BoxShadow(
                  color: widget.color.withRed((widget.color.red * 0.7).round())
                      .withGreen((widget.color.green * 0.7).round())
                      .withBlue((widget.color.blue * 0.7).round()),
                  offset: const Offset(0, 8),
                ),
                // لمعة علوية خفيفة
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: widget.style?? TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))],
                ),
              ),
            ),
          ),

          // طبقة اللمعة المتحركة
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: AnimatedBuilder(
                animation: _shineController,
                builder: (context, child) {
                  return FractionalTranslation(
                    translation: Offset(_shineController.value * 3 - 1.5, 0),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.4, 0.5, 0.6],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}