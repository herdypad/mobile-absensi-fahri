import 'dart:convert';
import 'dart:io';

import 'package:absen_dosen_mobile/app/api/presensi_api.dart';
import 'package:absen_dosen_mobile/app/api/service_upload.dart';
import 'package:absen_dosen_mobile/app/data/data_absensi.dart';
import 'package:absen_dosen_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constants/constant.dart';
import '../../../../utils/app_storage.dart';
import '../../../../widget/show_dialog.dart';
import '../../../api/auth_api.dart';
import '../../../data/user_m.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  Rx<UserM> dataUser = UserM().obs;
  RxList<DataAbsensiM> dataAbsen = <DataAbsensiM>[].obs;
  RxList<DataAbsensiM> dataAbsenToday = <DataAbsensiM>[].obs;

  RxBool isLoading = false.obs;

  RxBool isRadius = false.obs;
  RxBool isAbsenMasuk = false.obs;
  RxString fileName = ''.obs;

  RxBool isLoadingRadius = false.obs;

  RxString filePathProfile = "".obs;

  //lokasi hp
  RxDouble lat1 = 0.0.obs;
  RxDouble long1 = 0.0.obs;

  //lokasi kampus
  RxDouble lat2 = 0.0.obs;
  RxDouble long2 = 0.0.obs;

  RxDouble distance = 0.0.obs;

  //adress
  RxString adressUser = "".obs;

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
  void onInit() async {
    super.onInit();
    initData();
    getData(true);
    cekLokasi();
    getFileProfilePath();

    // await Permission.location.isRestricted;
    // await Permission.mediaLibrary;
    // await Permission.accessMediaLocation;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> cekFotoNotEmty() async {
    showPopUpInfo(
        onPress: () {
          updateFoto();
        },
        success: false,
        title: 'Berhasil',
        description:
            'Anda Belum Melakukan Foto Profile, Silahkan Update Profile');
  }

  Future<void> getFileProfilePath() async {
    final response = await http
        .get(Uri.parse("${BASE_URL}api/file/${dataUser.value.user?.foto}"));

    if (response.statusCode != 200) {
      cekFotoNotEmty();
      // return;
    }
    final bytes = response.bodyBytes;
    // Menyimpan gambar ke file sementara
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/temp_image.jpg");
    await file.writeAsBytes(bytes);

    filePathProfile(file.path);
  }

  Future<void> cekLokasi() async {
    lat2(double.parse(dataUser.value.location!.lat.toString()));
    long2(double.parse(dataUser.value.location!.long.toString()));
    getLocation();
  }

  Future<void> getData(bool status) async {
    if (status) {
      isLoading(true);
    }

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
    dataAbsenToday(List.from(b.map((e) => DataAbsensiM.fromJson(e))));
    try {
      if (dataAbsenToday.value[0].jamMasuk!.isNotEmpty) {
        isAbsenMasuk(true);
      }
    } catch (e) {
      isAbsenMasuk(false);
    }

    isLoading(false);
  }

  Future<void> logOut() async {
    await AppStorage.delete(
      key: CACHE_ACCESS_TOKEN,
    );
  }

  Future<bool> clockin(file) async {
    final data = await Permission.camera.request();
    if (data.isDenied) {
      return false;
    }

    final picker = ImagePicker();
    // final file =
    //     await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (file != null) {
      cekFoto('Proses Verifikasi Wajah');
      final data = await ServiceUpload().uploadFileAbsen(
          filex: file.path,
          id: dataUser.value.user!.id.toString(),
          url: 'api/clockin');

      final a = jsonDecode(data);
      Get.back();
      showPopUpInfo(
          success: true, title: 'Berhasil', description: '${a['message']}');
      getData(false);

      return true;
    }
    return false;
  }

  Future<bool> updateFoto() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    if (file != null) {
      cekFoto('Update Profile');
      final data = await ServiceUpload().uploadFileAbsen(
          filex: file.path,
          id: '${dataUser.value.user!.id}',
          url: 'api/updatefoto');

      // final a = jsonDecode(data);

      Get.back();

      //dan menutu semua pop up
      Get.back();

      final respon = await AuthApi.whoiam();
      dataUser(UserM.fromJson(respon));

      getFileProfilePath();

      // showPopUpInfo(
      //     success: true, title: 'Berhasil', description: '${a['message']}');

      return true;
    }
    return false;
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

  Future<void> getLocation() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isDenied) {
      if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      } else {
        PermissionStatus secondStatus = await Permission.location.request();
        if (secondStatus.isGranted) {
          // Izin diberikan
        }
      }
    }

    isLoadingRadius(true);

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(milliseconds: 15000));

    lat1(position.latitude);
    long1(position.longitude);
    logSysT("TAG", "Latitude1: ${lat1.value}, Longitude: ${long1.value}");
    logSysT("TAG", "Latitude2: ${lat2.value}, Longitude: ${long2.value}");

    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              timeLimit: Duration(milliseconds: 15000))
          .then((position) {
        lat1(position.latitude);
        long1(position.longitude);
        placemarkFromCoordinates(position.latitude, position.longitude)
            .then((placemarks) {
          // ignore: prefer_interpolation_to_compose_strings
          String alamatLengkap = placemarks[0].name! +
              ',' +
              placemarks[0].street! +
              ',' +
              placemarks[0].locality! +
              ',' +
              placemarks[0].subAdministrativeArea! +
              ',' +
              placemarks[0].administrativeArea!;

          logSysT("TAG1", alamatLengkap);
          adressUser(alamatLengkap);
        });
      });

      isLoadingRadius(false);
    } catch (e) {
      logSysT("TAG", "cek Lokasi done $e");
      isLoadingRadius(false);
    }

    calculateDistance();
  }

  void calculateDistance() {
    if (lat1 != 0.0 && lat2 != 0.0) {
      double meters = Geolocator.distanceBetween(
        lat1.value,
        long1.value,
        lat2.value,
        long2.value,
      );

      distance(meters);

      if (meters < 500) {
        isRadius(true);
      } else {
        isRadius(false);
      }

      logSys("Jarak dari titik sekarang sampai dengan office :$meters meters");
    }
  }
}
