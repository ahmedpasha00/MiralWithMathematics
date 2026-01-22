import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../../../core/models/question_model.dart';
import '../repo/counting_repository.dart';

part 'counting_state.dart';

class CountingCubit extends Cubit<CountingState> {
  final CountingRepository repository;
  String currentCategory = "";

  CountingCubit(this.repository) : super(CountingState());

  // ✨ دالة تشغيل صوت السؤال (معدلة لمنع الغش) ✨
  void playCurrentQuestionAudio(String currentLang, {bool isAutoPlay = true}) {
    final question = state.currentQuestion;
    if (question != null) {
      // الأقسام اللي عاوزين نوقف فيها الصوت التلقائي (العد، العمليات، الأعداد)
      bool isCountingOrMath =
          question.type == QuestionType.addition ||
          question.type == QuestionType.placeValue ||
          currentCategory.contains("العد") ||
          currentCategory.contains("الاعداد") ||
          currentCategory.contains("العمليات");

      // لو التشغيل تلقائي (أول ما السؤال يفتح) وكان من الأقسام الممنوعة.. اخرج وماتشغلش
      if (isAutoPlay && isCountingOrMath) {
        return;
      }

      try {
        String path = (currentLang == 'ar')
            ? question.audioPathAr
            : question.audioPathEn;

        FlameAudio.play(path);
      } catch (e) {
        print("الصوت غير موجود في المسار المحدد: $e");
      }
    }
  }

  void initCategory(String category) {
    currentCategory = category;
    emit(state.copyWith(step: CountingStep.levels, categoryName: category));
  }

  void selectLevel(int levelIndex, String lang) {
    List<QuestionModel> selectedQuestions;
    if (currentCategory.contains("قسم الاعداد")) {
      selectedQuestions = repository.getPlaceValueQuestions(levelIndex);
    } else if (currentCategory.contains("العمليات")) {
      selectedQuestions = repository.getOperationsQuestions(levelIndex);
    } else if (currentCategory.contains("القياس")) {
      selectedQuestions = repository.getMeasurementQuestions(
        levelIndex,
        currentCategory,
      );
    } else if (currentCategory.contains("الهندسة")) {
      selectedQuestions = repository.getGeometryQuestions(levelIndex);
    } else {
      if (levelIndex == 0)
        selectedQuestions = repository.getLevel1Questions();
      else if (levelIndex == 1)
        selectedQuestions = repository.getLevel2Questions();
      else
        selectedQuestions = repository.getLevel3Questions();
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

    // هيدخل هنا ويشيك.. لو هندسة أو قياس هيشتغل، لو غير كدة هيسكت
    playCurrentQuestionAudio(lang, isAutoPlay: true);
  }

  void nextQuestion({required bool earnStar, required String lang}) async {
    int updatedStars = earnStar ? state.starsEarned + 1 : state.starsEarned;

    // 💡 حركة ذكية: لو الطفل جاوب صح (earnStar == true)
    // بنشغل الصوت هنا عشان يسمع الإجابة (حتى في العد والعمليات)
    if (earnStar) {
      playCurrentQuestionAudio(
        lang,
        isAutoPlay: false,
      ); // false يعني مش تلقائي، ده تشغيل متعمد
    }

    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
        state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          starsEarned: updatedStars,
        ),
      );

      // تشغيل صوت السؤال التالي (لو هندسة أو قياس بس)
      playCurrentQuestionAudio(lang, isAutoPlay: true);
    } else {
      emit(
        state.copyWith(step: CountingStep.success, starsEarned: updatedStars),
      );

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null && updatedStars > 0) {
          await repository.updateStudentStars(userId, updatedStars);
        }
      } catch (e) {
        print("خطأ في تحديث النجوم: $e");
      }
    }
  }

  void startWithLevels() {
    emit(
      state.copyWith(
        step: CountingStep.levels,
        currentQuestionIndex: 0,
        starsEarned: 0,
      ),
    );
  }

  void goBack() {
    if (state.step == CountingStep.questions) {
      emit(state.copyWith(step: CountingStep.levels, starsEarned: 0));
    } else {
      emit(state.copyWith(step: CountingStep.levels, currentQuestionIndex: 0));
    }
  }
}
