import 'package:dio/dio.dart';
import 'package:ilk_uygulama/core/constants/app_constants.dart';

class DioClient {
  // Dışarıdan erişilebilecek Dio nesnemiz
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        // Temel URL'yi otomatik olarak her isteğin başına ekler
        baseUrl: AppConstants.baseUrl,
        // İstek zaman aşımı süreleri (sunucu 5 saniye içinde cevap vermezse hata fırlatır)
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        // Gönderdiğimiz ve beklediğimiz veri tipinin JSON olduğunu belirtiyoruz
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}