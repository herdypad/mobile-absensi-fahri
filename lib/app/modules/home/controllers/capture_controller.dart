import 'dart:convert';
import 'dart:io';

import 'package:absen_dosen_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:absen_dosen_mobile/utils/app_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widget/show_dialog.dart';
import '../../../api/service_upload.dart';

class CaptureController extends GetxController {
  // Inisialisasi variabel kamera
  CameraController? cameraController;
  List<CameraDescription> availableCamera = [];

  // Inisialisasi variabel foto
  XFile? _takenPicture;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController?.dispose();
  }

  Future<void> _initializeCamera() async {
    availableCamera = await availableCameras();
    bool cameraFound = false;
    for (var camera in availableCamera) {
      if (camera.lensDirection == CameraLensDirection.front) {
        cameraController = CameraController(
          camera,
          ResolutionPreset.medium,
        );
        await cameraController?.initialize();
        cameraFound = true;
        break;
      }
    }
    if (!cameraFound) {
      print('No front-facing camera found.');
      return;
    }
  }

  Future<void> takePicture() async {
    try {
      if (cameraController != null &&
          !cameraController!.value.isTakingPicture) {
        final XFile picture = await cameraController!.takePicture();

        _takenPicture = picture;
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> uploadPicture() async {
    final homeC = Get.find<HomeController>();

    if (_takenPicture != null) {
      logSys("hahdahsdhadhas");
      final File file = File(_takenPicture!.path);
      try {
        cekFoto('Proses Verifikasi Wajah');

        final data = await ServiceUpload().uploadFileAbsen(
            filex: file.path,
            id: homeC.dataUser.value.user!.id.toString(),
            url: 'api/clockin');

        final a = jsonDecode(data);
        Get.back();
        Get.back();
        showPopUpInfo(
            success: true, title: 'Berhasil', description: '${a['message']}');
        homeC.getData(false);
      } catch (e) {
        showPopUpInfo(success: true, title: 'Gagal', description: '${e}');
        Get.back();
        logSys("erroror");
      }
    }
    return '';
  }

  void cekFoto(description) {
    bool success = true;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 3),
              Text(
                description ?? '',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void buttonCapture() async {
    await takePicture();
    if (_takenPicture != null) {
      String photoURL = await uploadPicture();
      if (photoURL.isNotEmpty) {
        DateTime now = DateTime.now();

        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
}
