import 'package:ilk_uygulama/features/auth/domain/repositories/auth_repository.dart';

// Use Case, uygulamada tek bir işi yapmaktan sorumludur (Buradaki iş: Giriş Yapmak).
class LoginUseCase {
  final AuthRepository repository;

  // Repository'yi dışarıdan enjekte alıyoruz
  LoginUseCase(this.repository);

  // Bu sınıf doğrudan çağrıldığında (`call` metodu sayesinde) repository'deki login fonksiyonunu tetikler
  Future<String> call(String username, String password) async {
    return await repository.login(username, password);
  }
}