import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miral_with_mathematics/core/widget/common_game_background.dart';
import 'package:miral_with_mathematics/core/widget/custom_cartoon_button.dart';
import 'package:miral_with_mathematics/feature/counting/presentation/ui/counting_screen.dart';
import 'package:miral_with_mathematics/feature/counting/presentation/ui/videoIntro_screen.dart';
import 'package:rive/rive.dart';
import '../../../../core/widget/audio_manager.dart';
import '../../../../main.dart';
import '../../../counting/data/cubit/counting_cubit.dart';
import '../../../counting/data/repo/counting_repository.dart';
import '../../../sitteng/presentation/ui/sitteng_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  SMIBool? _awakeInput;
  SMITrigger? _surpriseTrigger;
  StateMachineController? _controller;
  Timer? _sleepTimer;

  AudioPlayer? _snoringPlayer;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'SM');
    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      _awakeInput = controller.findSMI('Awake');
      _surpriseTrigger = controller.findSMI('Supprise');
      if (_awakeInput != null) _wakeUpPanda();
    }
  }

  void _wakeUpPanda() {
    if (_awakeInput?.value == false) {
      _stopSnoring();
      FlameAudio.play(
        'click.mp3',
      ).catchError((e) => print("Audio not ready: $e"));
      // When panda wakes up, resume background music.
      AudioManager().playBackgroundMusic();
    }
    setState(() => _awakeInput?.value = true);
    _resetTimer();
  }

  void _goToSleep() {
    if (mounted) {
      setState(() => _awakeInput?.value = false);
      // When panda sleeps, pause background music and start snoring.
      AudioManager().pauseBackgroundMusic();
      _startSnoring();
    }
  }

  void _resetTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(const Duration(seconds: 30), () => _goToSleep());
  }

  void _startSnoring() async {
    if (mounted) {
      try {
        _stopSnoring();
        _snoringPlayer = await FlameAudio.loop('sleep_panda.mp4');
      } catch (e) {
        print("Snoring file missing or error: $e");
      }
    }
  }

  void _stopSnoring() {
    if (_snoringPlayer != null) {
      _snoringPlayer!.stop();
      _snoringPlayer!.dispose();
      _snoringPlayer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    FlameAudio.audioCache.loadAll(['click.mp3', "sleep_panda.mp4"]);
    _resetTimer();
    AudioManager().playBackgroundMusic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _sleepTimer?.cancel();
    _stopSnoring();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    // When navigating to ANY other screen, just handle the panda's state.
    // The background music will continue playing by default.
    _sleepTimer?.cancel();
    _stopSnoring();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    // When returning to the home screen, restore its state.
    _resetTimer(); // Restart the inactivity timer.

    // If the panda was sleeping, resume snoring.
    // The main background music is handled by other methods (like returning from video)
    // and should already be playing if it's supposed to.
    if (_awakeInput?.value == false) {
      _startSnoring();
    }
    super.didPopNext();
  }

  void _showLanguageDialog({
    required BuildContext context,
    required String arVideo,
    required String enVideo,
    required Widget nextScreen,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        backgroundColor: Colors.yellow[50],
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: Center(
          child: FittedBox(
            child: Text(
              "اختار اللغة - Choose Language",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
        ),
        content: SizedBox(
          width: 280.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _languageOption(
                title: "العربية",
                flag: "🇪🇬",
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToVideo(arVideo, nextScreen);
                },
              ),
              _languageOption(
                title: "English",
                flag: "🇺🇸",
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToVideo(enVideo, nextScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOption({
    required String title,
    required String flag,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.w),
            ),
            child: FittedBox(
              child: Text(flag, style: TextStyle(fontSize: 25.sp)),
            ),
          ),
          SizedBox(height: 5.h),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToVideo(String path, Widget nextScreen) async {
    // SPECIAL CASE: Pause music for the video screen.
    await AudioManager().pauseBackgroundMusic();
    if (!mounted) return;

    // Navigate and wait for the screen to be popped.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoIntroScreen(videoPath: path, nextScreen: nextScreen),
      ),
    );

    // When back from the video, resume music ONLY IF the panda is awake.
    if (mounted && _awakeInput?.value == true) {
      AudioManager().playBackgroundMusic();
    }
  }

  void _navigateToSettings() async {
    // For regular navigation, just push the screen.
    // `didPushNext` will handle the panda state. Music will continue.
    _resetTimer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SittengScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _wakeUpPanda(),
      child: Scaffold(
        body: CommonGameBackground(
          child: Stack(
            children: [
              Positioned(
                bottom: 30.h,
                right: 120.w,
                child: GestureDetector(
                  onTap: () {
                    _surpriseTrigger?.fire();
                    FlameAudio.play('click.mp3');
                    _resetTimer();
                  },
                  child: SizedBox(
                    width: 380.w,
                    height: 380.h,
                    child: RiveAnimation.asset(
                      'assets/lottie/pnada_sleep.riv',
                      onInit: _onRiveInit,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 45.h,
                left: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الصف الأول
                    Row(
                      children: [
                        _buttonWrapper(
                          "العد".tr(),
                          const Color(0xffFFCF5F),
                          () {
                            _showLanguageDialog(
                              context: context,
                              arVideo: "assets/audio/arapi.mp4",
                              enVideo: "assets/audio/eng.mp4",
                              nextScreen: BlocProvider(
                                create: (context) =>
                                    CountingCubit(CountingRepository())
                                      ..startWithLevels(),
                                child: const CountingScreen(
                                  categoryName: 'قسم العد',
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 15.w),
                        _buttonWrapper(
                          "العمليات".tr(),
                          const Color(0xff98D761),
                          () {
                            _showLanguageDialog(
                              context: context,
                              arVideo: "assets/audio/Operations.mp4",
                              enVideo: "assets/audio/eng.mp4",
                              nextScreen: BlocProvider(
                                create: (context) =>
                                    CountingCubit(CountingRepository())
                                      ..initCategory("قسم العمليات")
                                      ..startWithLevels(),
                                child: CountingScreen(
                                  categoryName: 'قسم العمليات',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    // الصف الثاني
                    Row(
                      children: [
                        _buttonWrapper(
                          "اﻷﻋداد".tr(),
                          const Color(0xff70D6FF),
                          () {
                            _showLanguageDialog(
                              context: context,
                              arVideo: "assets/audio/Numbers.mp4",
                              enVideo: "assets/audio/eng.mp4",
                              nextScreen: BlocProvider(
                                create: (context) =>
                                    CountingCubit(CountingRepository())
                                      ..initCategory("قسم الاعداد")
                                      ..startWithLevels(),
                                child: CountingScreen(
                                  categoryName: 'قسم الاعداد',
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 15.w),
                        _buttonWrapper(
                          "القياس".tr(),
                          const Color(0xffB19CD9),
                          () {
                            _showLanguageDialog(
                              context: context,
                              arVideo: "assets/audio/Measurement.mp4",
                              enVideo: "assets/audio/eng.mp4",
                              nextScreen: BlocProvider(
                                create: (context) =>
                                    CountingCubit(CountingRepository())
                                      ..initCategory("قسم القياس")
                                      ..startWithLevels(),
                                child: CountingScreen(
                                  categoryName: 'قسم القياس',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    // الصف الثالث المعدل (الهندسة في النص)
                    SizedBox(
                      // العرض ده هو (عرض زرار + مسافة + عرض زرار) = (110+15+110)
                      width: (110.w * 2) + 15.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // هيخلي الزرار في نص المساحة المحددة فوق
                        children: [
                          _buttonWrapper(
                            "الهندسة".tr(),
                            const Color(0xffB14Cf9),
                            () {
                              _showLanguageDialog(
                                context: context,


                                arVideo: "assets/audio/Geometry.mp4",
                                enVideo: "assets/audio/eng.mp4",
                                nextScreen: BlocProvider(
                                  create: (context) =>
                                      CountingCubit(CountingRepository())
                                        ..initCategory("قسم الهندسه")
                                        ..startWithLevels(),
                                  child: CountingScreen(
                                    categoryName: 'قسم الهندسة',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: SizedBox(
                  width: 100.w,
                  height: 70.h,
                  child: CustomCartoonButton(
                    text: "الإعدادات".tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    color: Colors.redAccent,
                    onTap: () {
                      FlameAudio.play('click.mp3');
                      _navigateToSettings();
                    },
                    backgroundColor: Colors.cyanAccent,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: _buttonWrapper(
                  "الأبطال الأوائل".tr(),
                  const Color(0xffFF9F43),
                  () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonWrapper(String text, Color color, VoidCallback onTapAction) {
    return SizedBox(
      width: 110.w,
      height: 65.h,
      child: CustomCartoonButton(
        text: "",
        color: color,
        onTap: () {
          FlameAudio.play('click.mp3');
          _resetTimer();
          onTapAction();
        },
        backgroundColor: Colors.greenAccent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
