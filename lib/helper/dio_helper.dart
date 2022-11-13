import 'package:dio/dio.dart';

import '../../constance/strings.dart';

class DioHelper {
  static
  Dio? dio;
static init(){
  BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,);
  dio = Dio(options);
}


  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
  dio!.options.headers = {
    'Content-Type': 'application/json',
    'Authorization': token??'',
    'lang':lang,
  };
    return dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token??'',
      'lang':lang,
    };
    return await dio!.post(
      url,
      data: data,
    );
  }static

  Future<Response> updateData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token??'',
      'lang':lang,
    };
    return await dio!.put(
      url,
      data: data,
    );
  }
}
