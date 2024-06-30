import 'package:dio/dio.dart';

abstract class ApiService {
  static final Dio _dio = Dio();
  static Future<Response> post({
    required String url,
    required dynamic data,
    required String token,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    var response = _dio.post(
      url,
      data: data,
      options: Options(
        headers: headers ??
            {'Authorization': 'Bearer $token', 'Content-Type': contentType},
      ),
    );
    return response;
  }
}
