import 'package:absen_dosen_mobile/app/controllers/user_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> startTime() async {
    final userC = Get.find<UserInfoController>();
    userC.getDatauser();
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
      ),
      body: Center(
        child: Center(
          child: Lottie.asset('assets/screen.json'),
        ),
      ),
    );
  }
}
