import 'package:get/get.dart';

import 'package:absen_dosen_mobile/app/modules/home/controllers/capture_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get..put(CaptureController());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
