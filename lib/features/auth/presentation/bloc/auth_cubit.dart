import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilk_uygulama/features/auth/domain/usecases/login_usecase.dart';
import 'auth_state.dart';

// UI ile Domain katmanı arasında köprü kuran Cubit sınıfı
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  // Başlangıç durumu olarak 'AuthInitial' veriyoruz
  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  // Giriş yap butonuna basıldığında çağrılacak fonksiyon
  Future<void> login(String username, String password) async {
    // 1. İstek atılıyor bilgisini (Loading) arayüze bildir
    emit(AuthLoading());

    try {
      // 2. UseCase aracılığıyla FastAPI'den token iste
      final token = await loginUseCase(username, password);
      
      // 3. İstek başarılı olursa token ile birlikte Success durumunu fırlat
      emit(AuthSuccess(token));
    } catch (e) {
      // 4. Hata çıkarsa Error durumu ile birlikte hatayı fırlat
      emit(AuthError(e.toString()));
    }
  }
}