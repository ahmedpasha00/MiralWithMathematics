import 'package:easy_localization/easy_localization.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miral_with_mathematics/core/widget/common_game_background.dart';
import 'package:miral_with_mathematics/core/widget/Interactive_panda_widget.dart';
import 'package:miral_with_mathematics/core/widget/custom_cartoon_button.dart';
import '../../data/cubit/counting_cubit.dart';

class CountingScreen extends StatefulWidget {
  final String categoryName;
  final String videoPath;

  const CountingScreen({
    super.key,
    required this.categoryName,
    this.videoPath = "",
  });

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  bool _isFirstAttempt = true;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _playClickSound() {
    FlameAudio.play('click.mp3').catchError((e) => print("Audio error: $e"));
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
    setState(() {
      _isFirstAttempt = false;
    });
    FlameAudio.play('wrong.mp3').catchError((e) => print("Audio error: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGameBackground(
        child: Stack(
          children: [
            Positioned(
              top: 15.h,
              left: 0,
              right: 190.w,
              child: IgnorePointer(
                child: BlocBuilder<CountingCubit, CountingState>(
                  builder: (context, state) {
                    if (state.step == CountingStep.success)
                      return const SizedBox.shrink();
                    return Center(
                      child: Text(
                        widget.categoryName.tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            _buildPandaAvatar(),
            BlocBuilder<CountingCubit, CountingState>(
              builder: (context, state) {
                if (state.step == CountingStep.levels) {
                  return _buildLevelsView(context);
                } else if (state.step == CountingStep.questions) {
                  return _buildMainGameBoard(context, state);
                } else if (state.step == CountingStep.success) {
                  return _buildSuccessView(context, state);
                }
                return const SizedBox.shrink();
              },
            ),

            _buildTopUI(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsView(BuildContext context) {
    return Positioned(
      right: 40.w,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              text: "easy_level".tr(),
              color: Colors.green,
              onTap: () => context.read<CountingCubit>().selectLevel(0),
            ),
            SizedBox(height: 20.h),
            _buildActionButton(
              text: "medium_level".tr(),
              color: Colors.orange,
              onTap: () => context.read<CountingCubit>().selectLevel(1),
            ),
            SizedBox(height: 20.h),
            _buildActionButton(
              text: "hard_level".tr(),
              color: Colors.redAccent,
              onTap: () => context.read<CountingCubit>().selectLevel(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGameBoard(BuildContext context, CountingState state) {
    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) return const SizedBox.shrink();

    bool isOperations = widget.categoryName.contains('العمليات');

    return Positioned(
      left: 90.w,
      top: 90.h,
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          double offset = 0.0;
          if (_shakeController.value > 0) {
            offset =
                (0.5 - (0.5 - _shakeController.value).abs()) *
                    20 *
                    ((0.5 - _shakeController.value) > 0 ? 1 : -1);
          }
          return Transform.translate(offset: Offset(offset, 0), child: child);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 220.w,
                  height: 300.h,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff224422),
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: const Color(0xff8B4513),
                      width: 10.w,
                    ),
                  ),
                  child: Center(
                    child: isOperations
                        ? _buildAdditionLayout(currentQuestion)
                        : _buildCountingLayout(currentQuestion),
                  ),
                ),
                ..._buildStarBadges(state.starsEarned),
              ],
            ),

            SizedBox(width: 15.w),

            SizedBox(
              height: 200.h,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentQuestion.options.map((option) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: _buildOptionButton(
                        context,
                        option,
                        currentQuestion.count,
                        state,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- التعديل لربط بيانات الجمع والطرح من الكيوبت ---
  Widget _buildAdditionLayout(dynamic question) {
    // نستخدم firstNum و secondNum بدلاً من تقسيم الـ count يدوياً
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // رسم صور الرقم الأول
              _imageGroup(question.firstNum, question.imagePath),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  // تبديل العلامة ديناميكياً بناءً على نوع السؤال
                  question.isAddition ? "+" : "-",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // رسم صور الرقم الثاني
              _imageGroup(question.secondNum, question.imagePath),
            ],
          ),
        ),
        // عرض العملية الحسابية بالأرقام أسفل الصور لزيادة الاستيعاب
        SizedBox(height: 12.h),
        Text(
          "${question.firstNum} ${question.isAddition ? '+' : '-'} ${question.secondNum} = ؟",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCountingLayout(dynamic question) {
    int crossAxisCount = question.count <= 4 ? 2 : 3;

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 280.w,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            childAspectRatio: 1,
          ),
          itemCount: question.count,
          itemBuilder: (context, index) =>
              Image.asset(question.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _imageGroup(int count, String path) {
    return SizedBox(
      width: count > 3 ? 110.w : 75.w,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.w,
        runSpacing: 4.h,
        children: List.generate(
          count,
              (index) =>
              Image.asset(path, width: 40.w, height: 55.h, fit: BoxFit.contain),
        ),
      ),
    );
  }

  List<Widget> _buildStarBadges(int stars) {
    return [
      _buildBadgeAt(stars, 0, top: -15.h, left: 40.w),
      _buildBadgeAt(stars, 1, top: -15.h, left: 110.w),
      _buildBadgeAt(stars, 2, top: -15.h, left: 180.w),
      _buildBadgeAt(stars, 3, right: -15.w, top: 60.h),
      _buildBadgeAt(stars, 4, right: -15.w, top: 130.h),
      _buildBadgeAt(stars, 5, right: -15.w, top: 200.h),
      _buildBadgeAt(stars, 6, bottom: -15.h, left: 40.w),
      _buildBadgeAt(stars, 7, bottom: -15.h, left: 110.w),
      _buildBadgeAt(stars, 8, bottom: -15.h, left: 180.w),
      _buildBadgeAt(stars, 9, left: -15.w, top: 60.h),
      _buildBadgeAt(stars, 10, left: -15.w, top: 130.h),
      _buildBadgeAt(stars, 11, left: -15.w, top: 200.h),
    ];
  }

  Widget _buildBadgeAt(
      int starsEarned,
      int badgeIndex, {
        double? top,
        double? bottom,
        double? left,
        double? right,
      }) {
    bool isSolved = (badgeIndex < starsEarned);
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 35.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: isSolved ? Colors.yellow : Colors.grey.shade400,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSolved ? Colors.orange : Colors.white,
            width: 3.w,
          ),
        ),
        child: Icon(
          Icons.star,
          size: 20.sp,
          color: isSolved ? Colors.orange : Colors.white,
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context,
      int value,
      int correctAnswer,
      CountingState state,
      ) {
    return InkWell(
      onTap: () {
        if (value == correctAnswer) {
          _playClickSound();
          String audio = context.locale.languageCode == 'ar'
              ? state.currentQuestion!.audioPathAr
              : state.currentQuestion!.audioPathEn;
          FlameAudio.play(audio);
          context.read<CountingCubit>().nextQuestion(earnStar: _isFirstAttempt);
          setState(() {
            _isFirstAttempt = true;
          });
        } else {
          _triggerShake();
        }
      },
      child: Container(
        width: 40.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white, width: 3.w),
        ),
        child: Center(
          child: Text(
            value.toString().tr(),
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPandaAvatar() {
    return Positioned(
      left: -55.w,
      bottom: -25.h,
      child: SizedBox(
        width: 220.w,
        height: 480.h,
        child: InteractivePandaWidget(
          key: InteractivePandaWidget.pandaKey,
          width: 200,
          height: 380,
        ),
      ),
    );
  }

  Widget _buildTopUI(BuildContext context) {
    return Positioned(
      top: 30.h,
      right: 20.w,
      child: InkWell(
        onTap: () {
          _playClickSound();
          context.read<CountingCubit>().goBack();
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 12.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, CountingState state) {
    return Positioned(
      top: 10,
      bottom: 0,
      right: 10,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.orange, width: 5.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🎉🎉🎉", style: TextStyle(fontSize: 15.sp)),
              SizedBox(height: 10.h),
              Text(
                "ممتاز يا بطل!",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              Text(
                "نجومك: ${state.starsEarned}",
                style: TextStyle(fontSize: 18.sp, color: Colors.orange),
              ),
              SizedBox(height: 15.h),
              _buildActionButton(
                text: "العب مرة أخرى",
                color: Colors.green,
                onTap: () {
                  _playClickSound();
                  context.read<CountingCubit>().startWithLevels();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 180.w,
      height: 85.h,
      child: CustomCartoonButton(
        text: text,
        color: color,
        backgroundColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}