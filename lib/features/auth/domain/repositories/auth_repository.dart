// Bu arayüz (interface), domain katmanının veri kaynağına nasıl bağlanacağını tanımlar.
abstract class AuthRepository {
  // Kullanıcı adı ve şifre alarak giriş yapmayı ve geriye Token (String) döndürmeyi taahhüt eder
  Future<String> login(String username, String password);
}