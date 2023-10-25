import 'dart:convert';

import 'package:absen_dosen_mobile/app/api/auth_api.dart';
import 'package:absen_dosen_mobile/app/api/presensi_api.dart';
import 'package:absen_dosen_mobile/app/api/service_upload.dart';
import 'package:absen_dosen_mobile/app/data/data_absensi.dart';
import 'package:absen_dosen_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/constant.dart';
import '../../../../utils/app_storage.dart';
import '../../../../widget/show_dialog.dart';
import '../../../data/user_m.dart';

class HomeController extends GetxController {
  Rx<UserM> dataUser = UserM().obs;
  RxList<DataAbsensiM> dataAbsen = <DataAbsensiM>[].obs;
  RxList<DataAbsensiM> dataAbsenToday = <DataAbsensiM>[].obs;

  RxBool isLoading = false.obs;
  RxBool isRadius = false.obs;
  RxString fileName = ''.obs;

  Future<void> initData() async {
    isLoading(true);
    try {
      final args = Get.arguments;
      if (args != null) {
        dataUser(args);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    initData();
    getData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getData() async {
    isLoading(true);

    //riwayat presensi
    final respon =
        await PresensiApi.riwayat(dataUser.value.user!.id.toString());
    final a = respon['data'];
    logSys(respon['message']);
    dataAbsen(List.from(a.map((e) => DataAbsensiM.fromJson(e))));

    //riwayat presensi today
    final respon2 =
        await PresensiApi.riwayatToday(dataUser.value.user!.id.toString());
    final b = respon2['data'];
    logSys(respon['message']);
    dataAbsenToday(List.from(a.map((e) => DataAbsensiM.fromJson(e))));

    isLoading(false);
  }

  Future<void> logOut() async {
    await AppStorage.delete(
      key: CACHE_ACCESS_TOKEN,
    );
  }

  Future<bool> clockin() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (file != null) {
      cekFoto('Proses Verifikasi Wajah');
      final data = await ServiceUpload()
          .uploadFileAbsen(filex: file.path, id: '2', url: 'api/clockin');

      final a = jsonDecode(data);
      Get.back();
      showPopUpInfo(
          success: true, title: 'Berhasil', description: '${a['message']}');
      getData();

      return true;
    }
    return false;
  }

  Future<bool> updateFoto() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (file != null) {
      cekFoto('Update Profile');
      final data = await ServiceUpload()
          .uploadFileAbsen(filex: file.path, id: '2', url: 'api/updatefoto');

      final a = jsonDecode(data);

      Get.back();

      showPopUpInfo(
          success: true, title: 'Berhasil', description: '${a['message']}');

      return true;
    }
    return false;
  }

  void cekFoto(description) {
    bool success = true;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 3),
              Text(
                description ?? '',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
