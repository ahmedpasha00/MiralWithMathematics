part of 'leaderboard_cubit.dart';

@immutable
sealed class LeaderboardState {}

// الحالة الأولى: أول ما نفتح الصفحة
final class LeaderboardInitial extends LeaderboardState {}

// الحالة الثانية: لما نكون بنجيب البيانات من الفايربيز
final class LeaderboardLoading extends LeaderboardState {}

// الحالة الثالثة: لما البيانات توصل بنجاح ومعاها قائمة الأبطال
final class LeaderboardSuccess extends LeaderboardState {
  final List<UserModel> topPlayers; // قائمة المستخدمين اللي هنعرضهم

  LeaderboardSuccess(this.topPlayers);
}

// الحالة الرابعة: لو حصل مشكلة في النت أو السيرفر
final class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError(this.message);
}