import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miral_with_mathematics/core/widget/language_toggle_button.dart';
import 'package:rive/rive.dart';
import 'package:flame_audio/flame_audio.dart';

// تأكد من صحة هذه المسارات في مشروعك
import 'package:miral_with_mathematics/core/widget/falling_balloons_background.dart';
import '../../../../core/widget/custom_cartoon_button.dart';
import 'package:miral_with_mathematics/core/widget/cousttom_text_form_filed.dart';
import '../../../home/presentation/ui/home.dart';
import '../../data/cubit/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  StateMachineController? _teddyController;
  SMIBool? _Check;
  SMIBool? _handsUp;
  SMINumber? _Look;
  SMITrigger? _success;
  SMITrigger? _fail;

  bool isLogin = true;

  @override
  void initState() {
    super.initState();

    // إجبار الشاشة على الوضع الطولي فور دخول هذه الصفحة
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _nameController.addListener(() {
      if (_Look != null) {
        _Look!.value = _nameController.text.length.toDouble() * 1.5;
      }
    });

    _nameFocusNode.addListener(() => _Check?.value = _nameFocusNode.hasFocus);
    _passwordFocusNode.addListener(
          () => _handsUp?.value = _passwordFocusNode.hasFocus,
    );
    _confirmPasswordFocusNode.addListener(
          () => _handsUp?.value = _confirmPasswordFocusNode.hasFocus,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _playClickSound() => FlameAudio.play('click.mp3');

  void _showChildMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.sentiment_very_dissatisfied
                  : Icons.sentiment_very_satisfied,
              color: Colors.white,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.orange : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  void _handleAuthAction() {
    _playClickSound();
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    _Check?.value = false;
    _handsUp?.value = false;

    String name = _nameController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      _fail?.fire();
      _showChildMessage("يا بطل، الخانات فاضية! اكتب اسمك وسرك ✍️");
      return;
    }
    if (password.length < 8) {
      _fail?.fire();
      _showChildMessage("كلمة السر قصيرة! لازم 8 أرقام أو حروف 🛡️");
      return;
    }
    if (!isLogin && password != _confirmPasswordController.text.trim()) {
      _fail?.fire();
      _showChildMessage("كلمة السر مش زي بعض! ركز يا بطل 🧐");
      return;
    }

    context.read<AuthCubit>().executeAuth(
      name: name,
      password: password,
      isLogin: isLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          _success?.fire();
          _showChildMessage(
            isLogin
                ? "أهلاً بك مرة أخرى يا بطل! 🎉"
                : "تم تسجيلك بنجاح! 🏆 مستعد للعب؟",
            isError: false,
          );

          Future.delayed(const Duration(seconds: 2), () async {
            if (mounted) {
              // قلب الشاشة عرض قبل الانتقال للهوم
              await SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
            }
          });
        } else if (state is AuthErrorState) {
          _fail?.fire();
          String errorMessage = "فيه مشكلة صغيرة! حاول تاني يا بطل ❌";

          if (state.errorMessage.contains('network-request-failed')) {
            errorMessage = "النت هرب مننا! تأكد إنك واصل بالإنترنت يا بطل 🌐";
          } else if (state.errorMessage.contains('invalid-credential') ||
              state.errorMessage.contains('user-not-found')) {
            errorMessage = "الاسم أو كلمة السر مش مظبوطين، ركز يا بطل 🧐";
          } else if (state.errorMessage.contains('email-already-in-use')) {
            errorMessage = "الاسم ده موجود قبل كدة، جرب اسم تاني يا بطل ✨";
          }
          _showChildMessage(errorMessage);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _Check?.value = false;
            _handsUp?.value = false;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFB3E5FC),
            body: Stack(
              children: [
                const FallingBalloonsBackground(count: 15),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            const LanguageToggleButton(),
                            SizedBox(height: 10.h),
                            Transform.translate(
                              offset: Offset(0, 30.h),
                              child: SizedBox(
                                height: 320.h,
                                child: RiveAnimation.asset(
                                  "assets/lottie/login.riv",
                                  fit: BoxFit.contain,
                                  onInit: (artboard) {
                                    _teddyController =
                                        StateMachineController.fromArtboard(
                                          artboard,
                                          "State Machine 1",
                                        );
                                    if (_teddyController != null) {
                                      artboard.addController(_teddyController!);
                                      _Check = _teddyController!
                                          .findSMI<SMIBool>('Check');
                                      _handsUp = _teddyController!
                                          .findSMI<SMIBool>('hands_up');
                                      _Look = _teddyController!
                                          .findSMI<SMINumber>('Look');
                                      _success = _teddyController!
                                          .findSMI<SMITrigger>('success');
                                      _fail = _teddyController!
                                          .findSMI<SMITrigger>('fail');
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 6.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15.r,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLogin ? "دخول الأبطال" : "بطل جديد",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  CousttomTextFormFiled(
                                    controller: _nameController,
                                    focusNode: _nameFocusNode,
                                    hintText: "اسمك الجميل",
                                    icon: Icons.face_rounded,
                                    themeColor: Colors.blueAccent,
                                  ),
                                  SizedBox(height: 15.h),
                                  CousttomTextFormFiled(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    hintText: "كلمة السر (8+)",
                                    icon: Icons.vpn_key_rounded,
                                    themeColor: Colors.purpleAccent,
                                    isPassword: true,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  if (!isLogin) ...[
                                    SizedBox(height: 15.h),
                                    CousttomTextFormFiled(
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocusNode,
                                      hintText: "أكد سرك",
                                      icon: Icons.check_circle_rounded,
                                      themeColor: Colors.orangeAccent,
                                      isPassword: true,
                                      keyboardType:
                                      TextInputType.visiblePassword,
                                    ),
                                  ],
                                  SizedBox(height: 25.h),
                                  state is AuthLoadingState
                                      ? const CircularProgressIndicator(
                                    color: Colors.orangeAccent,
                                  )
                                      : CustomCartoonButton(
                                    text: isLogin
                                        ? "انطلق!"
                                        : "سجلني يا بطل",
                                    backgroundColor: Colors.orangeAccent,
                                    onTap: _handleAuthAction,
                                    color: Colors.orangeAccent,
                                  ),
                                  SizedBox(height: 15.h),
                                  TextButton(
                                    onPressed: () {
                                      _playClickSound();
                                      setState(() => isLogin = !isLogin);
                                    },
                                    child: Text(
                                      isLogin
                                          ? "بطل جديد؟ سجل هنا"
                                          : "عندك حساب؟ ادخل من هنا",
                                      style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}