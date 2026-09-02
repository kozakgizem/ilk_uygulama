import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilk_uygulama/features/auth/domain/entities/user_entity.dart';
import 'package:ilk_uygulama/features/auth/domain/usecases/login_usecase.dart';

// 1. Durumlar (States)
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// 2. Mantık Yönetimi (Cubit)
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading()); // Yükleniyor durumunu arayüze bildir

    final result = await loginUseCase(email, password);

    result.fold(
      (error) => emit(AuthError(error.toString())), // Hata durumu
      (user) => emit(AuthSuccess(user)),             // Başarı durumu
    );
  }
}