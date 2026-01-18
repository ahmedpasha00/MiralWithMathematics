import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miral_with_mathematics/core/widget/common_game_background.dart';
import 'package:miral_with_mathematics/feature/auth/presentation/ui/auth_screen.dart';
import '../../../../core/widget/audio_manager.dart';
import '../../../auth/data/cubit/auth_cubit.dart';
import '../../../auth/repo/auth_repository.dart';
import '../../../home/presentation/ui/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. إجبار الشاشة تفتح بالعرض فوراً في السبلاش
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    AudioManager().playBackgroundMusic();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() => setState(() {}));

    _controller.forward().then((_) async {
      if (mounted) {

        final currentUser = FirebaseAuth.instance.currentUser;
        if(currentUser != null){
          // لو مسجل دخول: اقلب الشاشة عرض (احتياطي) وانقل للهوم
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }else{
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BlocProvider(
              create: (context) => AuthCubit(AuthRepository()),
              child: const AuthScreen(),
            )),
          );
        }


      }
    });
  }

  Color _getSmoothColor(double value) {
    if (value <= 0.5) {
      return Color.lerp(Colors.white, Colors.yellowAccent, value * 2)!;
    } else {
      return Color.lerp(Colors.yellowAccent, Colors.redAccent, (value - 0.5) * 2)!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFB3E5FC),
      body: CommonGameBackground(
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: const Alignment(0, -0.3),
                child: SizedBox(
                  height: 280.h, // معدل ليناسب وضع العرض
                  child: Image.asset("assets/images/splash_screen.png", fit: BoxFit.contain),
                ),
              ),
              Positioned(
                bottom: 40.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300.w, // عرض مناسب للوضع العرضي
                      height: 12.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: LinearProgressIndicator(
                          value: _animation.value,
                          valueColor: AlwaysStoppedAnimation<Color>(_getSmoothColor(_animation.value)),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "%${(_animation.value * 100).toInt()}",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}