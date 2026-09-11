import 'dart:html' as html show window;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';
class AppConstants {

static String get baseUrl {
  if (kIsWeb) {
    final host = html.window.location.hostname;
    final port = html.window.location.port;

    if (host == 'localhost' || host == '127.0.0.1') {
      return 'http://localhost:8000';
    }

    if (port.isEmpty || port == '80' || port == '443') {
      return 'http://$host';
    }

    return 'http://$host:$port';
  } else {
    const fallbackIp = 'http://192.168.1.100:8000';
    return fallbackIp;
  }
}

}