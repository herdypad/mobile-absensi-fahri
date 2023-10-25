import 'dart:async';

import '../utils/app_utils.dart';

class AppCycleService {
  factory AppCycleService() {
    return _instance;
  }
  AppCycleService._internal() {
    logSys('AppCylceService Initialized');
  }

  static final AppCycleService _instance = AppCycleService._internal();

  Timer? tokenExpiredTimer;

  Future<void> cekInternet() async {
    // bool result = await InternetConnectionChecker().hasConnection;
    // if (result == true) {
    //   return;
    // } else {
    //   await Get.offAllNamed(Routes.NOCONNECTION);
    return;
    // }
  }
}
