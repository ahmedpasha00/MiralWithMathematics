import 'dart:math';
import '../../../../core/models/question_model.dart';

class CountingRepository {
  final Random _random = Random();

  // ------------------ قسم القياس (Measurement) الجديد ------------------

  List<QuestionModel> getMeasurementQuestions(
    int levelIndex,
    String categoryName,
  ) {
    List<QuestionModel> questions = [];

    // 5 أسئلة للطول
    List<Map<String, dynamic>> lengthData = [
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
        "ar": "من هي المسطرة الأطول؟",
        "en": "Which is the longer ruler?",
        "opts": ["📏", "✏️"],
        "ans": "📏",
        "tag": "length",
      },
      {
        "ar": "من هو الأطول؟",
        "en": "Who is taller?",
        "opts": ["🧍", "👶"],
        "ans": "🧍",
        "tag": "length",
      },
      {
        "ar": "من هو الأقصر؟",
        "en": "Who is shorter?",
        "opts": ["🕯️", "🔦"],
        "ans": "🕯️",
        "tag": "length",
      },
    ];

    // 5 أسئلة للوزن
    List<Map<String, dynamic>> weightData = [
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
        "ar": "من هي السيارة الأثقل؟",
        "en": "Which is the heavier car?",
        "opts": ["🚗", "🚲"],
        "ans": "🚗",
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
        "ar": "من هو الأثقل؟",
        "en": "Who is heavier?",
        "opts": ["🚢", "🛶"],
        "ans": "🚢",
        "tag": "weight",
      },
    ];

    // دمج الأسئلة (5 طول + 5 وزن)
    List<Map<String, dynamic>> allMeasurementData = [
      ...lengthData,
      ...weightData,
    ];
    allMeasurementData.shuffle();

    for (var data in allMeasurementData) {
      List<dynamic> options = List.from(data['opts']);

      // في المستوى المتوسط والصعب بنضيف خيار تالت عشوائي عشان نصعبها
      if (levelIndex > 0) {
        options.add(data['tag'] == "length" ? "🐍" : "🍎");
      }

      questions.add(
        QuestionModel(
          type: QuestionType.measurement,
          count: 0,
          instructionAr: data['ar'],
          instructionEn: data['en'],
          options: options..shuffle(),
          correctOption: data['ans'],
          imagePath: '',
          audioPathAr: 'ar/measure_${data['tag']}.mp3',
          audioPathEn: 'en/measure_${data['tag']}.mp3',
        ),
      );
    }
    return questions;
  }

  // ------------------ قسم العد (Counting) ------------------

  List<QuestionModel> getLevel1Questions() {
    return List.generate(10, (index) {
      int count = index + 1;
      return QuestionModel(
        count: count,
        correctAnswer: count,
        imagePath: 'assets/images/splash_screen.png',
        options: [count, count + 1, count + 2]..shuffle(),
        audioPathAr: 'ar/$count.mp3',
        audioPathEn: 'en/$count.mp3',
      );
    })..shuffle();
  }

  List<QuestionModel> getLevel2Questions() {
    return List.generate(10, (index) {
      int count = index + 11;
      return QuestionModel(
        count: count,
        correctAnswer: count,
        imagePath: 'assets/images/splash_screen.png',
        options: [count, count - 1, count + 1]..shuffle(),
        audioPathAr: 'ar/$count.mp3',
        audioPathEn: 'en/$count.mp3',
      );
    })..shuffle();
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

  // ------------------ قسم العمليات (Addition & Subtraction) ------------------

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
      opts.shuffle();

      questions.add(
        QuestionModel(
          type: QuestionType.addition,
          count: result,
          correctAnswer: result,
          firstNum: n1,
          secondNum: n2,
          isAddition: isAdd,
          options: opts,
          imagePath: "assets/images/splash_screen.png",
          audioPathAr: "ar/$result.mp3",
          audioPathEn: "en/$result.mp3",
        ),
      );
    }
    return questions;
  }

  // ------------------ قسم الأعداد - الآحاد والعشرات ------------------

  List<QuestionModel> getPlaceValueQuestions(int levelIndex) {
    List<QuestionModel> questions = [];
    int maxRange = (levelIndex == 0) ? 10 : (levelIndex == 1 ? 15 : 20);

    for (int i = 0; i < 10; i++) {
      int number = _random.nextInt(maxRange) + 1;
      int ones = number % 10;
      int tens = number ~/ 10;

      bool askForOnes = (number < 10) ? true : _random.nextBool();
      int correctVal = askForOnes ? ones : tens;

      Set<dynamic> optsSet = {correctVal};
      optsSet.add(askForOnes ? tens : ones);

      while (optsSet.length < 3) {
        optsSet.add(_random.nextInt(10));
      }

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
