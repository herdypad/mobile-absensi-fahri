import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/presensi_controller.dart';

class PresensiView extends GetView<PresensiController> {
  const PresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Container loading_title(title) {
      return Container(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/loading.gif',
                scale: 2,
              ),
              Text(
                title,
              ),
            ],
          ),
        ),
      );
    }

    Widget bottomBar() {
      if (controller.isLoadingAbsen.value == false) {
        if (controller.presensi_status == 1) {
          return PresensiStatusNotif(
            title: 'Sukses',
            desc: 'Pengecekan biometric berhasil, presensi disimpan',
            backgroundColor: Colors.blue,
            button: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text("Back"),
            ),
          );
        } else {
          return Container(
            height: 170.h,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (controller.statusStep.value == 0)
                loading_title('Mengambil Lokasi...'),
              if (controller.statusStep.value == 1)
                Text(
                    controller.isFaceDetected.value
                        ? controller.isBlinkDetected.value
                            ? controller.isSmileDetected.value
                                ? "Tahan.."
                                : "Silahkan Senyum.."
                            : "Kedipkan Mata.."
                        : "Wajah Tidak Ditemukan",
                    style: TextStyle(color: Colors.black, fontSize: 20.sp)),
              if (controller.statusStep.value == 3) loading_title(''),
            ]),
          );
        }
      } else {
        return Container(
          height: 170.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/loading.gif',
              scale: 2,
            )
          ]),
        );
      }
    }

    Widget liveFeedBody() {
      return Obx(() => controller.isLoadingAbsen.isFalse
          ? Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Center(
                    child: CameraPreview(controller.cameraController!),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width / 3.5,
                    left: MediaQuery.of(context).size.width / 5,
                    right: MediaQuery.of(context).size.width / 5,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        //color: Colors.amber,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 2),
                      ),
                    ),
                  ),
                  // controller.customPaint ?? SizedBox(),

                  Positioned(bottom: 0, child: bottomBar()),

                  //show lokasi dan status radius
                  // Column(
                  //   children: [
                  //     SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       controller: ScrollController(),
                  //       child: Text(controller.adressUser.value.toString()),
                  //     ),
                  //     Text("Status Radius Kamu = ${controller.isRadius.value}")
                  //   ],
                  // ),
                ],
              ),
            )
          : SizedBox());
    }

    return Obx(() => controller.isGetLocation.isTrue
        ? Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: false,
              title: Text(
                "Liveness Detection",
              ),
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body:
                controller.isLoadingAbsen.isFalse ? liveFeedBody() : SizedBox(),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/loading.gif',
                    scale: 2,
                  ),
                  Text(
                    "Mengambil Lokasi...",
                  ),
                ],
              ),
            ),
          ));
  }
}

class PresensiStatusNotif extends StatelessWidget {
  String title;
  String desc;
  Color backgroundColor;
  Widget button;

  PresensiStatusNotif(
      {required this.title,
      required this.desc,
      required this.backgroundColor,
      required this.button});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.alarm,
                      size: 24.0,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: TextStyle(
                                fontSize: 12.sp,
                              )),
                          Text(desc,
                              style: TextStyle(
                                fontSize: 12.sp,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        button != null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(height: 44.h, child: button),
              )
            : const SizedBox()
      ]),
    );
  }
}
