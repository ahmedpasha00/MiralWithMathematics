// lib/feature/counting/data/repo/counting_repository.dart
import 'dart:math';

import '../../../../core/models/question_model.dart';

class CountingRepository {
  // المستوى الأول: من 1 إلى 10 (ملخبط)
  List<QuestionModel> getLevel1Questions() {
    List<QuestionModel> questions = List.generate(10, (index) {
      int count = index + 1;
      return QuestionModel(
        count: count,
        imagePath: 'assets/images/splash_screen.png',
        options: [count, count + 1, count + 2]..shuffle(),
        audioPathAr: 'audio/ar/count_$count.mp3',
        audioPathEn: 'audio/en/count_$count.mp3',
      );
    });

    return questions..shuffle(); // تلخبط ترتيب الأسئلة نفسها
  }

  // المستوى الثاني: من 11 إلى 20 (ملخبط)
  List<QuestionModel> getLevel2Questions() {
    List<QuestionModel> questions = List.generate(10, (index) {
      int count = index + 11;
      return QuestionModel(
        count: count,
        imagePath: 'assets/images/splash_screen.png',
        options: [count, count - 1, count + 1]..shuffle(),
        audioPathAr: 'audio/ar/count_$count.mp3',
        audioPathEn: 'audio/en/count_$count.mp3',
      );
    });

    return questions..shuffle(); // تلخبط ترتيب الأسئلة نفسها
  }

  // المستوى الثالث: دمج المستويين ولخبطتهم بالكامل
  List<QuestionModel> getLevel3Questions() {
    // بناخد كل الأسئلة من المستوى الأول والثاني
    List<QuestionModel> all = [
      ...getLevel1Questions(),
      ...getLevel2Questions()
    ];

    all.shuffle(); // لخبطة شاملة لكل الأسئلة

    // بناخد أول 12 سؤال فقط عشان يملوا الـ 12 نجمة اللي في التصميم
    return all.take(12).toList();
  }


  final Random _random = Random();

  List<QuestionModel> getOperationsQuestions(int level) {
    int maxNumber = level == 0 ? 5 : (level == 1 ? 10 : 20);
    List<QuestionModel> questions = [];

    for (int i = 0; i < 12; i++) {
      bool isAdd = _random.nextBool(); // اختيار عشوائي بين جمع وطرح
      int n1, n2, result;

      if (isAdd) {
        // توليد عملية جمع
        result = _random.nextInt(maxNumber - 1) + 2; // الناتج
        n1 = _random.nextInt(result - 1) + 1;
        n2 = result - n1;
      } else {
        // توليد عملية طرح
        n1 = _random.nextInt(maxNumber - 2) + 2; // الرقم الكبير
        n2 = _random.nextInt(n1 - 1) + 1; // الرقم الصغير
        result = n1 - n2;
      }

      // توليد خيارات عشوائية
      List<int> opts = [result];
      while (opts.length < 3) {
        int opt = _random.nextInt(maxNumber) + 1;
        if (!opts.contains(opt)) opts.add(opt);
      }
      opts.shuffle();

      questions.add(QuestionModel(
        count: result,
        firstNum: n1,
        secondNum: n2,
        isAddition: isAdd,
        options: opts,
        imagePath: "assets/images/splash_screen${_random.nextInt(5) + 1}.png", // صورة عشوائية
        audioPathAr: "ar/count_$result.mp3",
        audioPathEn: "en/count_$result.mp3",
      ));
    }
    return questions;
  }



}