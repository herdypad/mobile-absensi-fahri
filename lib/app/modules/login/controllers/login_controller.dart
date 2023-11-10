import 'package:absen_dosen_mobile/app/data/user_m.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constants/constant.dart';
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widget/show_dialog.dart';
import '../../../api/auth_api.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final cUsername = TextEditingController(text: "user@user.com");
  RxString username = ''.obs;
  bool isValidusername = false;

  final cPassword = TextEditingController(text: "123456");
  RxString password = ''.obs;

  RxBool passwordVisible = true.obs;

  RxBool isLoading = false.obs;

  Rx<UserM> dataUser = UserM().obs;

  @override
  void onInit() async {
    super.onInit();

    await Permission.camera.request();

    // await Permission.mediaLibrary;
    // await Permission.accessMediaLocation;
  }

  Future<void> login() async {
    try {
      isLoading(true);
      AppUtils.dismissKeyboard();

      final respon = await AuthApi.login(
          username: cUsername.text, password: cPassword.text);
      // logSys(respon.toString());

      if (respon['message'] == 'Login success') {
        dataUser(UserM.fromJson(respon));
        logSys(dataUser.value.user?.email ?? "tidak ada");

        //menyimpan ke login
        await AppStorage.write(
            key: CACHE_ACCESS_USERNAME, value: cUsername.text);
        await AppStorage.write(
          key: CACHE_ACCESS_PASSWORD,
          value: cPassword.text,
        );

        await AppStorage.write(
            key: CACHE_ACCESS_TOKEN, value: respon['access_token']);

        await Future.delayed(const Duration(seconds: 2));
        showToast(message: "Berhasil Login");
        isLoading(false);
        Get.offAllNamed(Routes.HOME, arguments: dataUser.value);
      }
    } catch (e) {
      isLoading(false);
      showPopUpInfo(
        success: false,
        title: 'Error',
        description: "Login Gagal",
      );
      logSys(e.toString());
    }
  }
}
