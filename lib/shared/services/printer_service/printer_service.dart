import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../dio_service/dio_response.dart';
import '../dio_service/dio_service.dart';
import '../shared_preference/shared_preference_service.dart';

class PrinterService {
  static SharedPreferenceService cSharedPreference =
      GetIt.instance<SharedPreferenceService>();

  static DioService cConexao = DioService();

  static late PrinterManager? printerManager;
  PrinterDevice? printerDevice;

  void initialize() {
    printerManager = PrinterManager.instance;
    if (cSharedPreference.getPrinter != '') {
      printerDevice = PrinterDevice.fromJson(cSharedPreference.getPrinter);
      printerManager!.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
              name: printerDevice!.name,
              productId: printerDevice!.productId,
              vendorId: printerDevice!.vendorId));
    }
  }

  Future<bool> execute(String senha) async {
    return await printerManager!
        .send(type: PrinterType.usb, bytes: await _print(senha));
  }

  static Future<List<int>> _print(String senha) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('Seja bem-vindo(a)!',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text('');
    bytes += generator.text('SENHA:',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text(senha,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
          align: PosAlign.center,
        ));

    DateTime now = DateTime.now();
    String dateTime = DateFormat("dd/MM/yyyy HH:mm:ss").format(now);

    bytes += generator.text('');
    bytes += generator.text(dateTime,
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<ApiResponse<dynamic>> getLastPassword() async {
    try {
      Response<Map<String, dynamic>> response;

      response = await cConexao.get(
        '/atendimento/ultima-senha',
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      return ApiResponse<dynamic>(
          cStatus: StatusReponse.success,
          cMessage: 'Ops! Ocorreu um erro. Por favor tente mais tarde!',
          cResult: response.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return ApiResponse<dynamic>(
          cStatus: StatusReponse.error_connection_internet,
          cMessage: 'Verifique sua conexão com a internet e tente novamente',
          cResult: '',
        );
      } else {
        switch (e.response?.statusCode) {
          case 400:
            {
              return ApiResponse<dynamic>(
                cStatus: StatusReponse.error,
                cMessage: 'Bad request',
                cResult: '',
              );
            }
          default:
            {
              if ((await InternetConnectionChecker().hasConnection == false) ||
                  (e.type == DioErrorType.connectTimeout) ||
                  (e.type == DioErrorType.receiveTimeout) ||
                  (e.type == DioErrorType.sendTimeout)) {
                return ApiResponse<dynamic>(
                  cStatus: StatusReponse.error_connection_internet,
                  cMessage: AppConsts.errorConnectionInternet,
                  cResult: e.response?.data,
                );
              } else {
                return ApiResponse<dynamic>(
                  cStatus: StatusReponse.error,
                  cMessage: AppConsts.errorConnectionInternet,
                  cResult: e.response?.data,
                );
              }
            }
        }
      }
    }
  }
}
