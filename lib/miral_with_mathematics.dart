

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature/splash/presentation/ui/splash_screen.dart';

class MiralWithMathematics extends StatelessWidget {
  const MiralWithMathematics({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,

        // ✨ السطور الثلاثة دي هي اللي هتحل المشكلة ✨
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: SplashScreen(),

      ),
    );
  }
}

