import 'package:dio/dio.dart';

class ApiProvider {
  static final Dio _dio = Dio();
  static const String _baseUrl = "http://192.168.1.7:5000";

  static Dio getInstance() {
    _dio.options.baseUrl = _baseUrl;
    return _dio;
  }
}
