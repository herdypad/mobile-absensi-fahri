import 'package:absen_dosen_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image(
                alignment: Alignment.topLeft,
                image: AssetImage('assets/logo.png'),
                height: 110,
              ),
            ),
            const Text(
              'Silakan isi data dibawah ini!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'nama',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      controller: controller.nicknameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          hintText: 'Masukan Nama'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        } else if (value.length < 3) {
                          return 'Nama harus terdiri dari minimal 3 huruf';
                        } else if (value.length > 50) {
                          return 'Nama harus terdiri dari maksimal 50 huruf';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NIP',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      controller: controller.nipController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          hintText: 'Masukan NIP'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIP tidak boleh kosong';
                        } else if (value.length < 3) {
                          return 'NIP harus terdiri dari minimal 3 huruf';
                        } else if (value.length > 50) {
                          return 'NIP harus terdiri dari maksimal 50 huruf';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'email',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          hintText: 'Masukan Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        } else if (value.length < 3) {
                          return 'Nama harus terdiri dari minimal 3 huruf';
                        } else if (value.length > 50) {
                          return 'Nama harus terdiri dari maksimal 50 huruf';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      obscureText: controller.passwordVisible.value,
                      controller: controller.passwordController,
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
                const SizedBox(
                  height: 10.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () {
                      controller.register();
                    },
                    child: const Text(
                      'Registrasi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun ? '),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(Routes.LOGIN);
                      },
                      child: const Text(
                        'Login',
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
          ],
        ),
      ),
    );
  }
}
