import 'package:get/get.dart';

import '../controllers/user_info_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get..put(UserInfoController());
  }
}
