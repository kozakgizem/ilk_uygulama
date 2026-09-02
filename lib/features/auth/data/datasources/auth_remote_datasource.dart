import 'package:ilk_uygulama/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Şimdilik sahte bir gecikme ve örnek kullanıcı döndürüyoruz (Ağ isteğini simüle ediyoruz)
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == "test@test.com" && password == "123456") {
      return UserModel(id: '1', email: email);
    } else {
      throw Exception('Kullanıcı adı veya şifre hatalı!');
    }
  }
}