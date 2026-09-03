// Arayüzün (UI) anlık durumlarını temsil eden temel soyut sınıf
abstract class AuthState {}

// Uygulama ilk açıldığındaki boş/başlangıç durumu
class AuthInitial extends AuthState {}

// Sunucuya istek atılırken ekranda dönen yüklenme (loading) durumu
class AuthLoading extends AuthState {}

// Giriş başarılı olduğunda sunucudan gelen token ile birlikte tetiklenen durum
class AuthSuccess extends AuthState {
  final String token;
  AuthSuccess(this.token);
}

// Hatalı şifre veya bağlantı kopması durumunda hata mesajını tutan durum
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}