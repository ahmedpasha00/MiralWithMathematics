import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flame_audio/flame_audio.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // نعرف اللغة الحالية عشان نغير شكل الزرار
    bool isArabic = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        // 1. تشغيل صوت النقرة بتاعك
        FlameAudio.play('click.mp3');

        // 2. تغيير اللغة
        if (isArabic) {
          context.setLocale(const Locale('en'));
        } else {
          context.setLocale(const Locale('ar'));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          // تغيير اللون حسب اللغة (أزرق للإنجليزي وبمبي للعربي مثلاً)
          color: isArabic ? Colors.pinkAccent : Colors.blueAccent,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.white, width: 3.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              isArabic ? "عربي" : "English",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontFamily: 'ComicSans', // لو عندك خط كرتوني
              ),
            ),
          ],
        ),
      ),
    );
  }
}