import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/widget/audio_manager.dart'; // تأكد أن المسار صحيح عندك

import 'feature/splash/presentation/ui/splash_screen.dart';
import 'main.dart';

class MiralWithMathematics extends StatefulWidget {
  const MiralWithMathematics({super.key});

  @override
  State<MiralWithMathematics> createState() => _MiralWithMathematicsState();
}

// ضفنا WidgetsBindingObserver عشان نراقب حالة التطبيق كله
class _MiralWithMathematicsState extends State<MiralWithMathematics> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // تفعيل مراقب حالة التطبيق (Lifecycle)
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // حذف المراقب عند إغلاق التطبيق نهائياً
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // الدالة السحرية اللي بتوقف الصوت لو خرجت من التطبيق من أي مكان
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // لو المستخدم خرج للهوم أو قفل الشاشة.. وقف الصوت
      AudioManager().stopMusic();
    } else if (state == AppLifecycleState.resumed) {
      // لو رجع فتح التطبيق تاني.. كمل تشغيل الموسيقى
      AudioManager().playBackgroundMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],

        // إعدادات اللغة والترجمة
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        // شاشة البداية
        home: const SplashScreen(),
      ),
    );
  }
}