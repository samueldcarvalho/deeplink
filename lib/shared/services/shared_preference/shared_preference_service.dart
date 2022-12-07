import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static late SharedPreferenceService sharedPreferenceService;
  static late SharedPreferences sharedPref;

  static Future<SharedPreferenceService> getInstance() async {
    sharedPreferenceService = SharedPreferenceService();
    sharedPref = await SharedPreferences.getInstance();
    return sharedPreferenceService;
  }

  Future setRememberPrinter(PrinterDevice printer) async {
    await sharedPref.setString('printer', printer.toJson());
  }

  String get getPrinter => sharedPref.getString('printer') ?? '';

  Future setEmptyPrinter() async {
    await sharedPref.remove('printer');
  }
}
