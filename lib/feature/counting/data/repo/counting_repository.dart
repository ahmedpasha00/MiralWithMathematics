import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/question_model.dart';

class CountingRepository {
  final Random _random = Random();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateStudentStars(String userId, int newStars) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'totalStars': FieldValue.increment(newStars),
      });
    } catch (e) {
      await _firestore.collection('users').doc(userId).set({
        'totalStars': newStars,
      }, SetOptions(merge: true));
    }
  }

  // دالة مساعدة لتحويل النص لاسم ملف (مثلاً: "أين المربع؟" -> "where_is_the_square")
  String _generateFileName(String enText) {
    return enText
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '') // حذف علامات الاستفهام والرموز
        .replaceAll(' ', '_'); // استبدال المسافات بـ _
  }

  // ------------------ قسم الهندسة ------------------
  List<QuestionModel> getGeometryQuestions(int levelIndex) {
    List<Map<String, dynamic>> selectedData = [];
    List<Map<String, dynamic>> level1 = [
      {
        "ar": "أين هو المربع؟",
        "en": "Where is the square?",
        "opts": ["🟦", "🟡", "🔺"],
        "ans": "🟦",
        "tag": "shape",
      },
      {
        "ar": "أين هي الدائرة؟",
        "en": "Where is the circle?",
        "opts": ["🟡", "🟩", "🔺"],
        "ans": "🟡",
        "tag": "shape",
      },
      {
        "ar": "أين هو المثلث؟",
        "en": "Where is the triangle?",
        "opts": ["🔺", "🟦", "🟠"],
        "ans": "🔺",
        "tag": "shape",
      },
      {
        "ar": "أين هو المستطيل؟",
        "en": "Where is the rectangle?",
        "opts": ["▭", "⚪", "💠"],
        "ans": "▭",
        "tag": "shape",
      },
      {
        "ar": "أي شكل يشبه التلفاز؟",
        "en": "Which looks like a TV?",
        "opts": ["📺", "🟡", "🔺"],
        "ans": "📺",
        "tag": "shape",
      },
      {
        "ar": "أي شكل يشبه قطعة البيتزا؟",
        "en": "Which looks like pizza?",
        "opts": ["🍕", "🟦", "⚪"],
        "ans": "🍕",
        "tag": "shape",
      },
      {
        "ar": "أي شكل يشبه الكره؟",
        "en": "Which looks like a ball?",
        "opts": ["⚽", "🔲", "🔼"],
        "ans": "⚽",
        "tag": "shape",
      },
      {
        "ar": "أين هو الشكل السداسي؟",
        "en": "Where is the hexagon?",
        "opts": ["⬡", "⚪", "🔲"],
        "ans": "⬡",
        "tag": "shape",
      },
      {
        "ar": "أين هو النجم؟",
        "en": "Where is the star?",
        "opts": ["⭐", "🔵", "🟥"],
        "ans": "⭐",
        "tag": "shape",
      },
      {
        "ar": "أي شكل يشبه الكتاب؟",
        "en": "Which looks like a book?",
        "opts": ["📖", "🟡", "🔺"],
        "ans": "📖",
        "tag": "shape",
      },
    ];

    List<Map<String, dynamic>> level2 = [
      {
        "ar": "كم ضلعاً للمربع؟",
        "en": "How many sides does a square have?",
        "opts": ["4", "3", "5"],
        "ans": "4",
        "tag": "logic",
      },
      {
        "ar": "الشباك يشبه شكل المربع؟",
        "en": "The window looks like a square?",
        "opts": ["🪟", "🟡", "🔺"],
        "ans": "🪟",
        "tag": "shape",
      },
      {
        "ar": "البرتقالة تشبه شكل الدائرة؟",
        "en": "The orange looks like a circle?",
        "opts": ["🟠", "🟦", "🔺"],
        "ans": "🟠",
        "tag": "shape",
      },
      {
        "ar": "كم رأس للمثلث؟",
        "en": "How many corners does a triangle have?",
        "opts": ["3", "4", "2"],
        "ans": "3",
        "tag": "logic",
      },
      {
        "ar": "الباب يشبه شكل المستطيل؟",
        "en": "The door looks like a rectangle?",
        "opts": ["🚪", "🟡", "🔷"],
        "ans": "🚪",
        "tag": "shape",
      },
      {
        "ar": "أين هو الشكل البيضاوي؟",
        "en": "Where is the oval?",
        "opts": ["🥚", "🔵", "🟥"],
        "ans": "🥚",
        "tag": "shape",
      },
      {
        "ar": "أي شكل ليس له أضلاع؟",
        "en": "Which shape has no sides?",
        "opts": ["⚪", "🟦", "🔺"],
        "ans": "⚪",
        "tag": "logic",
      },
      {
        "ar": "الهرم يشبه شكل المثلث؟",
        "en": "The pyramid looks like a triangle?",
        "opts": ["🔺", "🔲", "🟡"],
        "ans": "🔺",
        "tag": "shape",
      },
      {
        "ar": "المسطرة الطويلة تشبه المستطيل؟",
        "en": "The ruler looks like a rectangle?",
        "opts": ["📏", "🟡", "⭐"],
        "ans": "📏",
        "tag": "shape",
      },
      {
        "ar": "شكل الخيمة هو المثلث؟",
        "en": "The tent shape is triangle?",
        "opts": ["⛺", "📦", "🌕"],
        "ans": "⛺",
        "tag": "shape",
      },
    ];

    List<Map<String, dynamic>> level3 = [
      {
        "ar": "أين المربع داخل المربع؟",
        "en": "Where is the square inside the square?",
        "opts": ["回", "⚪ 🟦", "🟦 ⚪"],
        "ans": "回",
        "tag": "position",
      },
      {
        "ar": "أي شكل هو الأكبر؟",
        "en": "Which shape is the biggest?",
        "opts": ["🟥", "◼️", "▪️"],
        "ans": "🟥",
        "tag": "logic",
      },
      {
        "ar": "أين المربع الصغير؟",
        "en": "Where is the small square?",
        "opts": ["▪️", "◼️", "🟥"],
        "ans": "▪️",
        "tag": "logic",
      },
      {
        "ar": "أين الشكل الذي يجمع الدائرة والمربع؟",
        "en": "Which combines circle and square?",
        "opts": ["◙", "⚪", "🔳"],
        "ans": "◙",
        "tag": "logic",
      },
      {
        "ar": "أين النجمة بين المربعين؟",
        "en": "Where is the star between two squares?",
        "opts": ["🟦⭐🟦", "⭐🟦🟦", "🟦🟦⭐"],
        "ans": "🟦⭐🟦",
        "tag": "logic",
      },
      {
        "ar": "أين الكرة تحت المنضدة؟",
        "en": "Where is the ball under the table?",
        "opts": ["🪑\n⚽", "⚽\n🪑", "⚽ 🪑"],
        "ans": "🪑\n⚽",
        "tag": "position",
      },
      {
        "ar": "أي شكل يشبه عجلة السيارة؟",
        "en": "Which looks like a car wheel?",
        "opts": ["⚙️", "📦", "📐"],
        "ans": "⚙️",
        "tag": "shape",
      },
      {
        "ar": "أين الشكل المختلف؟",
        "en": "Where is the different shape?",
        "opts": ["🔺", "🔺", "🟦"],
        "ans": "🟦",
        "tag": "logic",
      },
    ];

    if (levelIndex == 0)
      selectedData = level1;
    else if (levelIndex == 1)
      selectedData = level2;
    else
      selectedData = level3;

    selectedData.shuffle();
    return selectedData.take(10).map((data) {
      String fileName = _generateFileName(data['en']); // تحويل السؤال لاسم ملف
      return QuestionModel(
        type: QuestionType.geometry,
        count: 0,
        instructionAr: data['ar'],
        instructionEn: data['en'],
        options: (data['opts'] as List)..shuffle(),
        correctOption: data['ans'],
        imagePath: '',
        audioPathAr: 'ar/$fileName.mp3',
        audioPathEn: 'en/$fileName.mp3',
      );
    }).toList();
  }

  // ------------------ قسم القياس ------------------
  List<QuestionModel> getMeasurementQuestions(
    int levelIndex,
    String categoryName,
  ) {
    List<Map<String, dynamic>> selectedData = [
      {
        "ar": "من هو الأطول؟",
        "en": "Who is taller?",
        "opts": ["🦒", "🐈"],
        "ans": "🦒",
        "tag": "length",
      },
      {
        "ar": "من هو الأقصر؟",
        "en": "Who is shorter?",
        "opts": ["🌱", "🌳"],
        "ans": "🌱",
        "tag": "length",
      },
      {
        "ar": "أيهما أطول؟",
        "en": "Which is longer?",
        "opts": ["📏", "✏️"],
        "ans": "📏",
        "tag": "length",
      },
      {
        "ar": "من هو الأطول؟",
        "en": "Who is taller?",
        "opts": ["🏢", "🏠"],
        "ans": "🏢",
        "tag": "length",
      },
      {
        "ar": "من هو الأثقل؟",
        "en": "Who is heavier?",
        "opts": ["🐘", "🐭"],
        "ans": "🐘",
        "tag": "weight",
      },
      {
        "ar": "من هو الأخف؟",
        "en": "Who is lighter?",
        "opts": ["🪶", "📦"],
        "ans": "🪶",
        "tag": "weight",
      },
      {
        "ar": "من هو الأثقل؟",
        "en": "Who is heavier?",
        "opts": ["🚜", "🛴"],
        "ans": "🚜",
        "tag": "weight",
      },
      {
        "ar": "من هو الأخف؟",
        "en": "Who is lighter?",
        "opts": ["🎈", "⚽"],
        "ans": "🎈",
        "tag": "weight",
      },
      {
        "ar": "من هو الأسرع؟",
        "en": "Who is faster?",
        "opts": ["🚀", "✈️"],
        "ans": "🚀",
        "tag": "speed",
      },
      {
        "ar": "من هو الأبطأ؟",
        "en": "Who is slower?",
        "opts": ["🐌", "🐇"],
        "ans": "🐌",
        "tag": "speed",
      },
    ];
    selectedData.shuffle();
    return selectedData.map((data) {
      List<dynamic> options = List.from(data['opts']);
      if (levelIndex > 0) {
        if (data['tag'] == "length")
          options.add("🍄");
        else if (data['tag'] == "weight")
          options.add("🍭");
        else
          options.add("🐥");
      }
      String fileName = _generateFileName(data['en']); // تحويل السؤال لاسم ملف
      return QuestionModel(
        type: QuestionType.measurement,
        count: 0,
        instructionAr: data['ar'],
        instructionEn: data['en'],
        options: options..shuffle(),
        correctOption: data['ans'],
        imagePath: '',
        audioPathAr: 'ar/$fileName.mp3',
        audioPathEn: 'en/$fileName.mp3',
      );
    }).toList();
  }

  // الأقسام الرقمية تبقى كما هي لأنها تنطق أرقام فقط
  List<QuestionModel> getLevel1Questions() {
    return List.generate(
      10,
      (index) => QuestionModel(
        count: index + 1,
        correctAnswer: index + 1,
        imagePath: 'assets/images/splash_screen.png',
        options: [index + 1, index + 2, index + 3]..shuffle(),
        audioPathAr: 'ar/${index + 1}.mp3',
        audioPathEn: 'en/${index + 1}.mp3',
      ),
    )..shuffle();
  }

  List<QuestionModel> getLevel2Questions() {
    return List.generate(
      10,
      (index) => QuestionModel(
        count: index + 11,
        correctAnswer: index + 11,
        imagePath: 'assets/images/splash_screen.png',
        options: [index + 11, index + 10, index + 12]..shuffle(),
        audioPathAr: 'ar/${index + 11}.mp3',
        audioPathEn: 'en/${index + 11}.mp3',
      ),
    )..shuffle();
  }

  List<QuestionModel> getLevel3Questions() {
    return List.generate(12, (index) {
      int count = _random.nextInt(20) + 1;
      return QuestionModel(
        count: count,
        correctAnswer: count,
        imagePath: 'assets/images/splash_screen.png',
        options: [count, count + 2, count - 1]..shuffle(),
        audioPathAr: 'ar/$count.mp3',
        audioPathEn: 'en/$count.mp3',
      );
    })..shuffle();
  }

  List<QuestionModel> getOperationsQuestions(int levelIndex) {
    int maxNumber = levelIndex == 0 ? 5 : (levelIndex == 1 ? 10 : 20);
    List<QuestionModel> questions = [];
    for (int i = 0; i < 10; i++) {
      bool isAdd = _random.nextBool();
      int n1, n2, result;
      if (isAdd) {
        result = _random.nextInt(maxNumber - 1) + 2;
        n1 = _random.nextInt(result - 1) + 1;
        n2 = result - n1;
      } else {
        n1 = _random.nextInt(maxNumber - 2) + 2;
        n2 = _random.nextInt(n1 - 1) + 1;
        result = n1 - n2;
      }
      List<dynamic> opts = [result];
      while (opts.length < 3) {
        int opt = _random.nextInt(maxNumber) + 1;
        if (!opts.contains(opt)) opts.add(opt);
      }
      questions.add(
        QuestionModel(
          type: QuestionType.addition,
          count: result,
          correctAnswer: result,
          firstNum: n1,
          secondNum: n2,
          isAddition: isAdd,
          options: opts..shuffle(),
          imagePath: "assets/images/splash_screen.png",
          audioPathAr: "ar/$result.mp3",
          audioPathEn: "en/$result.mp3",
        ),
      );
    }
    return questions;
  }

  List<QuestionModel> getPlaceValueQuestions(int levelIndex) {
    List<QuestionModel> questions = [];
    int maxRange = (levelIndex == 0) ? 10 : (levelIndex == 1 ? 15 : 20);
    for (int i = 0; i < 10; i++) {
      int number = _random.nextInt(maxRange) + 1;
      int ones = number % 10;
      int tens = number ~/ 10;
      bool askForOnes = (number < 10) ? true : _random.nextBool();
      int correctVal = askForOnes ? ones : tens;
      Set<dynamic> optsSet = {correctVal, askForOnes ? tens : ones};
      while (optsSet.length < 3) optsSet.add(_random.nextInt(10));
      questions.add(
        QuestionModel(
          type: QuestionType.placeValue,
          count: number,
          correctAnswer: correctVal,
          firstNum: askForOnes ? 1 : 2,
          options: optsSet.toList()..shuffle(),
          audioPathAr: 'ar/$number.mp3',
          audioPathEn: 'en/$number.mp3',
          imagePath: '',
        ),
      );
    }
    return questions;
  }
}
