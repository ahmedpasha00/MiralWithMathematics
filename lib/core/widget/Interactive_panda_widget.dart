import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class InteractivePandaWidget extends StatefulWidget {
  final double width;
  final double height;

  const InteractivePandaWidget({
    super.key,
    this.width = 300,
    this.height = 300,
  });

  // هذه الـ Key ستسمح لنا بالوصول للدالات من خارج الكلاس
  static final GlobalKey<InteractivePandaWidgetState> pandaKey = GlobalKey<InteractivePandaWidgetState>();

  @override
  State<InteractivePandaWidget> createState() => InteractivePandaWidgetState();
}

class InteractivePandaWidgetState extends State<InteractivePandaWidget> {
  SMITrigger? _successTrigger; // حركة النجاح (مثلاً القفز على القصبة)
  SMITrigger? _failTrigger;    // حركة الخطأ (مثلاً الرياح أو الحزن)
  StateMachineController? _controller;

  void _onRiveInit(Artboard artboard) {
    // تأكد من اسم الـ State Machine داخل ملف الـ Rive
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');

    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;

      // ملاحظة: استبدل 'Success' و 'Fail' بالأسماء الحقيقية للـ Triggers في ملف الـ Rive الخاص بك
      _successTrigger = controller.findSMI('Click');
      _failTrigger = controller.findSMI('Hover');
    }
  }

  // 1. دالة تفعيل حالة الإجابة الصحيحة
  void playSuccess() {
    _successTrigger?.fire();
    FlameAudio.play('success_sound.mp3'); // ضع اسم ملف الصوت الصحي هنا
  }

  // 2. دالة تفعيل حالة الإجابة الخاطئة
  void playFailure() {
    _failTrigger?.fire();
    FlameAudio.play('wrong_answer.mp3'); // ضع اسم ملف الصوت الخطأ هنا
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width.w,
      height: widget.height.h,
      child: RiveAnimation.asset(
        'assets/lottie/playing-panda (2).riv',
        onInit: _onRiveInit,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}