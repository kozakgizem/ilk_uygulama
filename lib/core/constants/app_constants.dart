import 'package:flutter/foundation.dart';

class AppConstants {
  // Dinamik BaseUrl yönetimi
  static String get baseUrl {
    // Eğer web ortamında çalışıyorsksa localhost, emülatör veya farklı ortamlar için burası esnetilebilir
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    } else {
      // Android emülatör için özel IP gerekebilir (örn: 10.0.2.2) veya canlı ortam URL'si
      return 'http://10.0.2.2:8000';
    }
  }
}