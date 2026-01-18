import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repo/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(AuthInitial());

  void executeAuth({required String name, required String password, required bool isLogin})async{
    emit(AuthLoadingState()); // الشاشة تطلع علامة تحميل

    try {
      if (isLogin) {
        await repository.login(name: name, password: password);
      } else {
        await repository.register(name: name, password: password);
      }
      emit(AuthSuccessState()); // الدب يضحك والشاشة تنقل
    } catch (e) {
      print("❌ Firebase Error: ${e.toString()}"); // السطر ده هيعرفنا المشكلة فين بالظبط
      // emit(AuthErrorState(e.toString()));
      emit(AuthErrorState(e.toString())); // الدب يزعل وتطلع رسالة غلط
    }

  }
}
