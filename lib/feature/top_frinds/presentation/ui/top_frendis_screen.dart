import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widget/common_game_background.dart';
import '../../../auth/model/user_model.dart';
import '../../data/cubit/leaderboard_cubit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // عملنا Container حول العنوان ليعطي شكل "يافطة"
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.orange[400],
            borderRadius: BorderRadius.circular(60.r),
            border: Border.all(color: Colors.white, width: 3.w),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4.r, offset: const Offset(0, 4))
            ],
          ),
          child: Text(
            "أبطال ميرال مع الرياضه 🏆".tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  BackButton(color: Colors.black,

        ), // لتوضيح زر الرجوع
      ),
      body: CommonGameBackground(
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.orange));
            } else if (state is LeaderboardSuccess) {
              return ListView.builder(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + 60.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 20.h,
                ),
                itemCount: state.topPlayers.length,
                itemBuilder: (context, index) {
                  final player = state.topPlayers[index];
                  return _buildPlayerCard(index + 1, player);
                },
              );
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPlayerCard(int rank, UserModel player) {
    Color cardColor = Colors.white.withOpacity(0.9);
    // تلوين خلفية الكرت لأول 3 مراكز
    if (rank == 1) cardColor = const Color(0xffFFF176); // ذهبي
    if (rank == 2) cardColor = const Color(0xffE0E0E0); // فضي
    if (rank == 3) cardColor = const Color(0xffFFCCBC); // برونزي

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _getBorderColor(rank), width: rank <= 3 ? 3.w : 1.w),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5.r, offset: const Offset(0, 3))
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        leading: _buildRankBadge(rank),
        title: Text(
          player.name ?? "بطل مجهول".tr(),
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.brown[900]),
        ),
        trailing: _buildScoreTrailing(player.totalStars.toString()),
      ),
    );
  }

  // ويدجت لعرض النجوم في نهاية الكرت
  Widget _buildScoreTrailing(String stars) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(stars, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.orange[900])),
          SizedBox(width: 4.w),
          const Icon(Icons.star, color: Colors.amber, size: 18),
        ],
      ),
    );
  }

  Color _getBorderColor(int rank) {
    if (rank == 1) return Colors.orange;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown[400]!;
    return Colors.white;
  }

  // الأيقونات المتغيرة حسب الترتيب
  Widget _buildRankBadge(int rank) {
    if (rank == 1) return _badgeText("👑"); // الملك
    if (rank == 2) return _badgeText("🥈"); // الثاني
    if (rank == 3) return _badgeText("🥉"); // الثالث
    if (rank <= 10) return _badgeText("⭐"); // توب 10

    // باقي المراكز رقم عادي داخل دائرة ملونة
    return CircleAvatar(
      radius: 15.r,
      backgroundColor: Colors.blueAccent.withOpacity(0.6),
      child: Text("$rank", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _badgeText(String emoji) {
    return Text(emoji, style: TextStyle(fontSize: 26.sp));
  }
}