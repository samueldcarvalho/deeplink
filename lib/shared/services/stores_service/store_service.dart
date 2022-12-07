import 'package:get_it/get_it.dart';

import '../shared_preference/shared_preference_service.dart';

class StoreService {
  static GetIt getIt = GetIt.instance;

  static Future regiterStores() async {
    getIt.registerSingleton<SharedPreferenceService>(
        await SharedPreferenceService.getInstance());
  }
}
