import 'package:dio/dio.dart';
import 'package:ilk_uygulama/core/network/dio_client.dart';

// Bu sınıf, FastAPI sunucumuzla ağ iletişimini kurarak kimlik doğrulama işlemlerini yönetir.
class AuthRemoteDataSource {
  final DioClient dioClient;

  // Dio istemcisini dışarıdan alıyoruz (Bağımlılık Enjeksiyonu - Dependency Injection)
  AuthRemoteDataSource({required this.dioClient});

  // Kullanıcı adı ve şifre alarak /auth/token endpoint'ine POST isteği atan fonksiyon
  Future<String> login(String username, String password) async {
    try {
      // FastAPI OAuth2 şeması standart olarak x-www-form-urlencoded formatında veri bekler
      final response = await dioClient.dio.post(
        '/auth/token', // Swagger dokümanındaki giriş uç noktası
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Sunucudan başarılı (200 OK) cevap döndüyse token bilgisini alıp dışarı döndürüyoruz
      if (response.statusCode == 200 && response.data != null) {
        return response.data['access_token'];
      } else {
        throw Exception('Giriş başarısız oldu.');
      }
    } catch (e) {
      // Bağlantı hatası veya yanlış kimlik bilgilerinde hata fırlatıyoruz
      throw Exception('Bağlantı hatası: $e');
    }
  }
}