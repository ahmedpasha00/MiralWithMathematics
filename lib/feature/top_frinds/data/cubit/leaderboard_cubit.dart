import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../auth/model/user_model.dart';
import '../repo/leaderboard_repository.dart';

part 'leaderboard_state.dart';
class LeaderboardCubit extends Cubit<LeaderboardState> {
  final LeaderboardRepository _repository;

  LeaderboardCubit(this._repository) : super(LeaderboardInitial());

  void loadLeaderboard() async {
    emit(LeaderboardLoading()); // أظهر علامة التحميل
    try {
      final players = await _repository.getTopPlayers();
      emit(LeaderboardSuccess(players)); // اعرض البيانات
    } catch (e) {
      emit(LeaderboardError("عذراً، لم نتمكن من جلب قائمة الأبطال")); // اعرض الخطأ
    }
  }
}