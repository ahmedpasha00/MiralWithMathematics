import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// استيراد ملفات مشروعك
import 'package:miral_with_mathematics/core/widget/common_game_background.dart';
import 'package:miral_with_mathematics/core/widget/custom_cartoon_button.dart';
import 'package:miral_with_mathematics/feature/auth/presentation/ui/auth_screen.dart';
import 'package:miral_with_mathematics/core/widget/language_toggle_button.dart';
import 'package:miral_with_mathematics/feature/auth/data/cubit/auth_cubit.dart';
import 'package:miral_with_mathematics/feature/auth/repo/auth_repository.dart';

class SittengScreen extends StatefulWidget {
  const SittengScreen({super.key});

  @override
  State<SittengScreen> createState() => _SittengScreenState();
}

class _SittengScreenState extends State<SittengScreen> {
  @override
  void initState() {
    super.initState();
    FlameAudio.audioCache.load('click.mp3');
  }

  // ✨ دالة التنبيه الموحدة - كل الخطوط 20sp ريسبونسف
  void _showCartoonDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    FlameAudio.play('click.mp3');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side:  BorderSide(color: Colors.orangeAccent, width: 4.w),
        ),
        title: Column(
          children: [
            Icon(Icons.star, color: Colors.orangeAccent, size: 40.r),
            SizedBox(height: 10.h),
            Text(
              title.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: Colors.blue),
            ),
          ],
        ),
        content: Text(
          message.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, color: Colors.black87),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              FlameAudio.play('click.mp3');
              Navigator.pop(context);
            },
            child: Text("cancel".tr(),
                style: TextStyle(color: Colors.grey, fontSize: 20.sp)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            onPressed: () {
              FlameAudio.play('click.mp3');
              Navigator.pop(context); // إغلاق التنبيه أولاً
              onConfirm();
            },
            child: Text("confirm".tr(),
                style: TextStyle(color: Colors.white, fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }

  // دالة الانتقال الفوري لشاشة الدخول
  void _navigateToAuth() async {
    if (!mounted) return;
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(AuthRepository()),
            child: const AuthScreen(),
          ),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGameBackground(
        child: Stack(
          children: [
            // 🔙 زرار الرجوع المطور (دائرة خلفية)
            Positioned(
              top: 30.h,
              left: 20.w,
              child: GestureDetector(
                onTap: () {
                  FlameAudio.play('click.mp3');
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 28.sp),
                ),
              ),
            ),

            // الوسط: العنوان وزرار اللغة
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("settings".tr(),
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const LanguageToggleButton(),
                ],
              ),
            ),

            // الأزرار السفلية
            Positioned(
              bottom: 40.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔥 زرار حذف الحساب مع معالجة الأمان
                  SizedBox(
                    width: 155.w,
                    height: 85.h,
                    child: CustomCartoonButton(
                      text: "delete_account".tr(),
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      color: Colors.red,
                      backgroundColor: Colors.redAccent,
                      onTap: () {
                        _showCartoonDialog(
                          title: "are_you_sure",
                          message: "delete_warning",
                          onConfirm: () async {
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await user.delete();
                                _navigateToAuth();
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'requires-recent-login') {
                                // تنبيه المستخدم بضرورة إعادة الدخول للحذف
                                _showCartoonDialog(
                                  title: "attention",
                                  message: "re_login_before_delete",
                                  onConfirm: () async {
                                    await FirebaseAuth.instance.signOut();
                                    _navigateToAuth();
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("error_occurred".tr())),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),

                  // 🚪 زرار تسجيل الخروج الفوري
                  SizedBox(
                    width: 145.w,
                    height: 85.h,
                    child: CustomCartoonButton(
                      text: "logout".tr(),
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      color: Colors.orange,
                      backgroundColor: Colors.orangeAccent,
                      onTap: () {
                        _showCartoonDialog(
                          title: "logout",
                          message: "logout_confirm_msg",
                          onConfirm: () async {
                            await FirebaseAuth.instance.signOut();
                            _navigateToAuth(); // انتقال فوري
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}