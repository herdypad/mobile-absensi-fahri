import 'package:absen_dosen_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../../widget/show_dialog.dart';
import '../../../api/auth_api.dart';

class RegisterController extends GetxController {
  // Controller
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nipController = TextEditingController();
  final jabatanController = TextEditingController();

  RxBool passwordVisible = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> register() async {
    isLoading(true);
    AppUtils.dismissKeyboard();

    final respon = await AuthApi.register(
        username: emailController.text,
        password: passwordController.text,
        nip: nicknameController.text,
        name: nicknameController.text);
    logSys(respon.toString());
    showToast(message: 'Berhasil Membuat User');

    if (respon['message'] == 'success') {
      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed(Routes.LOGIN);
    } else {
      showToast(message: respon['email'][0]);
    }
  }
}
