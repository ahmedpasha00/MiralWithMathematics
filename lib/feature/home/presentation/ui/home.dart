import 'package:easy_localization/easy_localization.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miral_with_mathematics/core/widget/common_game_background.dart'; // استيراد الخلفية
import 'package:miral_with_mathematics/core/widget/custom_cartoon_button.dart';
import 'package:miral_with_mathematics/core/widget/language_toggle_button.dart';
import '../../../sitteng/presentation/ui/sitteng_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FlameAudio.audioCache.load('click.mp3');
  }

  @override
  Widget build(BuildContext context) {
    // لضمان تحديث اللغة فوراً
    context.locale;

    return Scaffold(
      body: CommonGameBackground( // استخدمنا الـ Widget المشترك هنا
        child: Stack(
          children: [
            // زرار الإعدادات
            Positioned(
              bottom: 20.h,
              right: 20.w,
              child: SizedBox(
                width: 100.w,
                height: 80.h,
                child: CustomCartoonButton(
                  text: "الإعدادات".tr(),
                  color: Colors.red,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  onTap: () {
                    FlameAudio.play('click.mp3');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SittengScreen()),
                    );
                  },
                  backgroundColor: Colors.cyanAccent,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}