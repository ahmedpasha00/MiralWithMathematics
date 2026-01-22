enum QuestionType { counting, addition, placeValue, measurement }

class QuestionModel {
  final int count;
  final List<dynamic> options;
  final String imagePath;
  final String audioPathAr;
  final String audioPathEn;
  final bool isAddition;
  final int firstNum;
  final int secondNum;

  // --- الحقول الجديدة للآحاد والعشرات ---
  final int? ones;
  final int? tens;
  final int? correctAnswer;

  // --- حقول ألعاب القياس (الطول والوزن) ---
  final QuestionType type;
  final String? instructionAr;
  final String? instructionEn;
  final dynamic correctOption;

  QuestionModel({
    required this.count,
    required this.options,
    required this.imagePath,
    required this.audioPathAr,
    required this.audioPathEn,
    this.isAddition = true,
    this.firstNum = 0,
    this.secondNum = 0,
    this.ones,
    this.tens,
    this.correctAnswer,
    // قيم افتراضية
    this.type = QuestionType.counting,
    this.instructionAr,
    this.instructionEn,
    this.correctOption,
  });
}