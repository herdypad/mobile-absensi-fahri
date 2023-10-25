import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../api/auth_api.dart';

class RegisterController extends GetxController {
  // Controller
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
        name: nicknameController.text);
    // logSys(respon.toString());

    if (respon['message'] == 'Login success') {
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
