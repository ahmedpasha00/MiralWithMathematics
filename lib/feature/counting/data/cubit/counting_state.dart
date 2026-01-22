part of 'counting_cubit.dart';

enum CountingStep { levels, questions, success }

class CountingState {
  final CountingStep step;
  final int selectedLevelIndex;
  final int currentQuestionIndex;
  final List<QuestionModel> questions;
  final int starsEarned;
  final String categoryName; // حقل جديد لحفظ اسم القسم الحالي

  CountingState({
    this.step = CountingStep.levels,
    this.selectedLevelIndex = 0,
    this.currentQuestionIndex = 0,
    this.questions = const [],
    this.starsEarned = 0,
    this.categoryName = "",
  });

  QuestionModel? get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex] : null;

  CountingState copyWith({
    CountingStep? step,
    int? selectedLevelIndex,
    int? currentQuestionIndex,
    List<QuestionModel>? questions,
    int? starsEarned,
    String? categoryName,
  }) {
    return CountingState(
      step: step ?? this.step,
      selectedLevelIndex: selectedLevelIndex ?? this.selectedLevelIndex,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      questions: questions ?? this.questions,
      starsEarned: starsEarned ?? this.starsEarned,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
