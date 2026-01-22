import 'package:bloc/bloc.dart';
import '../../../../core/models/question_model.dart';
import '../repo/counting_repository.dart';

part 'counting_state.dart';

class CountingCubit extends Cubit<CountingState> {
  final CountingRepository repository;
  String currentCategory = "";

  CountingCubit(this.repository) : super(CountingState());

  // دالة تهيئة القسم
  void initCategory(String category) {
    currentCategory = category;
    emit(state.copyWith(step: CountingStep.levels, categoryName: category));
  }

  // دالة اختيار المستوى - محدثة لدعم القياس وكافة الأقسام
  void selectLevel(int levelIndex) {
    List<QuestionModel> selectedQuestions;

    // 1. فحص قسم الأعداد (الآحاد والعشرات)
    if (currentCategory.contains("قسم الاعداد")) {
      selectedQuestions = repository.getPlaceValueQuestions(levelIndex);
    }
    // 2. فحص قسم العمليات (جمع وطرح)
    else if (currentCategory.contains("العمليات")) {
      selectedQuestions = repository.getOperationsQuestions(levelIndex);
    }
    // 3. فحص قسم القياس (الطول والوزن) - الجديد
    else if (currentCategory.contains("القياس")) {
      selectedQuestions = repository.getMeasurementQuestions(levelIndex, currentCategory);
    }
    // 4. قسم العد العادي
    else {
      if (levelIndex == 0) {
        selectedQuestions = repository.getLevel1Questions();
      } else if (levelIndex == 1) {
        selectedQuestions = repository.getLevel2Questions();
      } else {
        selectedQuestions = repository.getLevel3Questions();
      }
    }

    emit(
      state.copyWith(
        step: CountingStep.questions,
        selectedLevelIndex: levelIndex,
        currentQuestionIndex: 0,
        starsEarned: 0,
        questions: selectedQuestions,
      ),
    );
  }

  // انتقال للسؤال التالي
  void nextQuestion({required bool earnStar}) {
    int updatedStars = earnStar ? state.starsEarned + 1 : state.starsEarned;

    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
        state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          starsEarned: updatedStars,
        ),
      );
    } else {
      emit(
        state.copyWith(step: CountingStep.success, starsEarned: updatedStars),
      );
    }
  }

  // إعادة البدء
  void startWithLevels() {
    emit(
      state.copyWith(
        step: CountingStep.levels,
        currentQuestionIndex: 0,
        starsEarned: 0,
      ),
    );
  }

  // العودة للخلف
  void goBack() {
    if (state.step == CountingStep.questions) {
      emit(state.copyWith(step: CountingStep.levels, starsEarned: 0));
    } else {
      emit(state.copyWith(step: CountingStep.levels, currentQuestionIndex: 0));
    }
  }
}