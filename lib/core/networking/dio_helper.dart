import 'package:dio/dio.dart';

class DioHelper {
  DioHelper._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      return dio!;
    } else {
      return dio!;
    }
  }
}
