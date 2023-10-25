import 'package:absen_dosen_mobile/utils/app_utils.dart';
import 'package:get/get.dart';

import '../../constants/constant.dart';
import '../../utils/app_storage.dart';
import '../api/auth_api.dart';
import '../data/user_m.dart';
import '../routes/app_pages.dart';

class UserInfoController extends GetxController {
  Rx<UserM> dataUser = UserM().obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getDatauser() async {
    final token = await AppStorage.read(key: CACHE_ACCESS_TOKEN);
    final user = await AppStorage.read(key: CACHE_ACCESS_USERNAME);
    final passUser = await AppStorage.read(key: CACHE_ACCESS_PASSWORD);

    logSys("asdasdasd" + token.length.toString());

    if (token.length == 0) {
      Get.offNamed(Routes.LOGIN);
      return;
    }

    final respon = await AuthApi.login(username: user, password: passUser);
    dataUser(UserM.fromJson(respon));
    if (respon['message'] == 'Login success') {
      Get.offNamed(Routes.HOME, arguments: dataUser.value);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
