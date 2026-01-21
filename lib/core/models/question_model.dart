class QuestionModel {
  final int count; // الناتج النهائي
  final List<int> options; // الخيارات
  final String imagePath;
  final String audioPathAr;
  final String audioPathEn;
  final bool isAddition; // true للجمع، false للطرح
  final int firstNum; // الرقم الأول في العملية
  final int secondNum; // الرقم الثاني

  QuestionModel({
    required this.count,
    required this.options,
    required this.imagePath,
    required this.audioPathAr,
    required this.audioPathEn,
    this.isAddition = true,
    this.firstNum = 0,
    this.secondNum = 0,
  });
}