// skill_model.dart
import 'question_model.dart'; // تأكد إن موديل السؤال موجود برضه

class SkillModel {
  final String skillName;
  final List<LevelModel> levels;

  SkillModel({required this.skillName, required this.levels});
}

class LevelModel {
  final String levelName;
  final List<QuestionModel> questions;

  LevelModel({required this.levelName, required this.questions});
}