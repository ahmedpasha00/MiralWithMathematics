import 'package:bloc/bloc.dart';
import '../../../../core/models/question_model.dart';
import '../repo/counting_repository.dart';

part 'counting_state.dart';

class CountingCubit extends Cubit<CountingState> {
  final CountingRepository repository;
  // أضفنا المتغير ده عشان نعرف إحنا في أنهي قسم (عد ولا عمليات)
  String currentCategory = "";

  CountingCubit(this.repository) : super(CountingState());

  // دالة لتهيئة القسم قبل اختيار المستوى
  void initCategory(String category) {
    currentCategory = category;
    emit(state.copyWith(step: CountingStep.levels));
  }

  // دالة اختيار المستوى - معدلة لتدعم العمليات والعد
  void selectLevel(int levelIndex) {
    List<QuestionModel> selectedQuestions;

    // فحص: هل القسم الحالي هو "العمليات"؟
    if (currentCategory.contains("العمليات")) {
      // بنادي الدالة الجديدة اللي عملناها في الريبو للجمع والطرح
      selectedQuestions = repository.getOperationsQuestions(levelIndex);
    } else {
      // لو مش عمليات، يبقى عد عادي ونستخدم المنطق القديم
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

  // الدالة المسؤولة عن نقل السؤال وحساب النجوم (بدون تغيير في المنطق)
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

  // للعودة لشاشة اختيار المستويات
  void startWithLevels() {
    emit(
      state.copyWith(
        // استخدمنا copyWith عشان نحافظ على الـ Category
        step: CountingStep.levels,
        currentQuestionIndex: 0,
        starsEarned: 0,
      ),
    );
  }

  // دالة الرجوع (Back)
  void goBack() {
    if (state.step == CountingStep.questions) {
      emit(state.copyWith(step: CountingStep.levels, starsEarned: 0));
    } else {
      emit(state.copyWith(step: CountingStep.levels, currentQuestionIndex: 0));
    }
  }
}
