import 'package:absen_dosen_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Obx(
          () => Form(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                Image(
                  image: const AssetImage("assets/logo.png"),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      TextFormField(
                        controller: controller.cUsername,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            hintText: 'Masukan Email'),
                        validator: (value) {
                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                          if (value!.isEmpty) {
                            return 'Masukan Email';
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return ('Email tidak valid');
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password',
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      TextFormField(
                        obscureText: controller.passwordVisible.value,
                        controller: controller.cPassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.passwordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                controller.passwordVisible.value =
                                    !controller.passwordVisible.value;
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            hintText: 'Masukan Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukan Password';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // const Text(
                //   'Lupa Password ?',
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.login();
                      }
                    },
                    child: controller.isLoading.isFalse
                        ? Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Or'),
                  ],
                ),

                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun ? '),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
