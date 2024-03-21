import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:absen_dosen_mobile/app/modules/home/controllers/capture_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/app_utils.dart';
import '../../../controllers/user_info_controller.dart';

class PresensiController extends GetxController {
  int cameraIndex = 1;
  int direction = 1;
  bool isShowButton = true;
  RxInt statusUpload = 0.obs;

  RxInt presensi_status = 0.obs;

  RxBool openCamera = false.obs;

  RxBool isLoadingAbsen = false.obs;
  RxBool isLoadPaint = false.obs;
  RxBool isGetLocation = true.obs;

  // Inisialisasi variabel kamera
  CameraController? cameraController;
  List<CameraDescription> cameras = [];

  // Inisialisasi variabel foto
  XFile? takenPicture;

  RxBool canProcess = true.obs;
  RxBool isBusy = false.obs;

  RxBool isRadius = true.obs;

  RxBool isFaceDetected = false.obs;
  RxBool isSmileDetected = false.obs;
  RxBool isBlinkDetected = false.obs;

  RxString title = "".obs;

  RxInt countPresensi = 1.obs;
  RxString last = '0'.obs;

  late CustomPaint? customPaint;

  //lokasi hp
  RxDouble lat1 = 0.0.obs;
  RxDouble long1 = 0.0.obs;

  //adress
  RxString adressUser = "".obs;

  RxInt statusStep = 4.obs;
  RxInt statusStep2 = 4.obs;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  final cCapture = Get.find<CaptureController>();

  ////////
  @override
  void onInit() async {
    super.onInit();
    await getLocation();
    isLoadingAbsen(true);
    await _initializeCamera();
    isLoadingAbsen(false);
    _startLiveFeed();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _stopLiveFeed();
    _faceDetector.close();
    canProcess(false);
  }

/////////////////implemtasi//////////////

  void resetFoto() {
    countPresensi++;
    cameraController?.resumePreview();
    cameraController?.setFlashMode(FlashMode.off);
    cameraController?.startImageStream(_processCameraImage);
    isFaceDetected(false);
    isSmileDetected(false);
    isBlinkDetected(false);
    presensi_status(0);
    statusStep(1);
  }

  Future<void> getLocation() async {
    isGetLocation(true);
    statusStep(1);
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      bool cameraFound = false;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          cameraController = CameraController(
            camera,
            ResolutionPreset.high,
            enableAudio: false,
            imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
                ? ImageFormatGroup.nv21
                : ImageFormatGroup.bgra8888,
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
    } on CameraException catch (e) {
      logSysT("Error Bor", e.toString());
    }
  }

  Future _startLiveFeed() async {
    try {
      isLoadPaint(true);
      cameraController?.setFlashMode(FlashMode.off);
      cameraController?.startImageStream(_processCameraImage);
    } catch (e) {
      logSysT("Error Bor", e.toString());
    }
  }

  Future _processCameraImage(CameraImage image) async {
    if (statusStep.value == 0) {
      return;
    }

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(image.width.toDouble(), image.height.toDouble());

      final camera = cameras[cameraIndex];
      final imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation);
      if (imageRotation == null) return;

      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw);
      if (inputImageFormat == null) return;

      final planeData = image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage =
          InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

      processImage(inputImage);
    } catch (e) {
      logSysT("Error Bor", e.toString());
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isRadius.value == false) {
      return;
    }
    try {
      logSysT("CAMERA", "processImage");
      if (!canProcess.value) return;
      if (isBusy.value) return;
      isBusy.value = true;

      final faces = await _faceDetector.processImage(inputImage);

      //deteksi wajak
      if (faces.length > 0) {
        isFaceDetected.value = true;
        isFaceDetected(true);
        // cameraController?.stopImageStream();

        logSysT("TAG2", "Berhasil Mendeteksi Wajah");
      } else {
        isFaceDetected.value = false;
        isBlinkDetected.value = false;
        isSmileDetected.value = false;
        logSysT("TAG2", "Tidak Mendeteksi Wajah");
      }

      //deketesi senyum
      for (Face face in faces) {
        if (face.leftEyeOpenProbability != null &&
            face.rightEyeOpenProbability != null) {
          final double? leftEyeOpenProbability = face.leftEyeOpenProbability;
          final double? rightEyeOpenProbability = face.rightEyeOpenProbability;

          // Blink Checking
          if (face.smilingProbability! < 0.3 &&
              leftEyeOpenProbability! <= 0.1 &&
              rightEyeOpenProbability! <= 0.1) {
            logSys("Berhasil Kedip");
            isBlinkDetected.value = true;
          }

          //smile checking
          if (isBlinkDetected.value) {
            if (face.smilingProbability != null) {
              final double? smileProb = face.smilingProbability;

              // Smile Checking
              if (smileProb! >= 0.8 &&
                  face.leftEyeOpenProbability! >= 0.5 &&
                  face.rightEyeOpenProbability! >= 0.5) {
                print("Berhasil Senyum");

                isSmileDetected.value = true;

                cameraController?.stopImageStream();

                Timer(Duration(milliseconds: 500), () async {
                  try {
                    await cameraController
                        ?.takePicture()
                        .then((XFile file) async {
                      cameraController?.pausePreview();
                      // cek presensi ke berapa
                      var last = countPresensi.value >= 3 ? '1' : '0';
                      logSys('ini absen ke $countPresensi');

                      statusStep(3);

                      File? f = await compressFile(File(file.path));

                      if (f != null) {
                        await cCapture.uploadPicture2(f);
                        presensi_status.value = 1;
                      }
                    });
                  } catch (e) {
                    logSysT("TAG", e.toString());
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                });
              }
            }
          }
        }
      }
////untuk paint tracking
      // if (inputImage.inputImageData?.size != null &&
      //     inputImage.inputImageData?.imageRotation != null) {
      //   final painter = FaceDetectorPainter(
      //       faces,
      //       inputImage.inputImageData!.size,
      //       inputImage.inputImageData!.imageRotation);
      //   customPaint = CustomPaint(painter: painter);
      // } else {
      //   String text = 'Faces found: ${faces.length}\n\n';
      //   for (final face in faces) {
      //     text += 'face: ${face.boundingBox}\n\n';
      //   }
      //   title.value = text;
      //   // _customPaint = null;
      // }

      isBusy(false);
      isLoadPaint(false);
    } catch (e) {
      logSysT("Error Bor", e.toString());
    }
  }

  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 30,
    );

    return result;
  }

  Future<void> sendFace() async {}

  Future<double> cekRadiusLokasi(double a2, double b2) async {
    double distanceInMeters =
        Geolocator.distanceBetween(lat1.value, long1.value, a2, b2);
    return distanceInMeters;
  }

  Future _stopLiveFeed() async {
    // await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
  }
}
