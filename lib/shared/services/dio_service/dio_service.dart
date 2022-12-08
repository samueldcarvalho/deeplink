import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

//import '../../../core/app_consts.dart';
import 'dio_interceptors_service.dart';

class DioService extends DioForNative {
  String urlAPI =
      "http://10.10.10.113:5000/api"; // "http://homolog.fila.autolac.com.br:5000/api";

  DioService() {
    options.baseUrl = urlAPI;
    options.connectTimeout = 8000;
    options.receiveTimeout = 8000;
    options.sendTimeout = 8000;

    options.responseType = ResponseType.json;

    interceptors.add(DioInterceptorsService());
  }
}
