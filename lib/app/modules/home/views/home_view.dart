import 'package:absen_dosen_mobile/app/modules/home/views/capture_view.dart';
import 'package:absen_dosen_mobile/app/routes/app_pages.dart';
import 'package:absen_dosen_mobile/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widget/show_dialog.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              controller.cekLokasi();
            },
            child: Stack(children: [
              ListView(),
              CustomScrollView(
                slivers: [
                  // Notifikasi, Text Absensi Dosen, dan LogOut
                  SliverAppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.orange,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.orange,
                    centerTitle: true,
                    title: const Text(
                      'Absensi Dosen',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          await controller.logOut();
                          Get.offNamed(Routes.LOGIN);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                              content: Text('Berhasil Logout'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: controller.isLoading.isFalse
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      height: 280 + 50,
                                      width: double.infinity,
                                      child: Container(
                                        height: 250,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(100),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 16,
                                                    right: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .updateFoto();
                                                          },
                                                          child: Container(
                                                            height: 60.0,
                                                            width: 60.0,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        "${BASE_URL}api/file/${controller.dataUser.value.user?.foto}"),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${controller.dataUser.value.user?.name}",
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      1.0),
                                                            ),
                                                            const SizedBox(
                                                              height: 6.0,
                                                            ),
                                                            Text(
                                                              "${controller.dataUser.value.user?.email}",
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  letterSpacing:
                                                                      0.8,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      width: 220,
                                                      decoration:
                                                          const BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 5,
                                                              color: Color(
                                                                  0x1A000000))
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Absen Masuk : ${controller.dataAbsenToday.length > 0 ? controller.dataAbsenToday?.value[0].jamMasuk : ""}',
                                                            style: const TextStyle(
                                                                letterSpacing:
                                                                    1.0,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            'Absen Keluar : ${controller.dataAbsenToday.length > 0 ? controller.dataAbsenToday?.value[0].jamPulang : ""}',
                                                            style: const TextStyle(
                                                                letterSpacing:
                                                                    1.0,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 7),
                                                    Text(
                                                        "jarak anda ${controller.distance.value}"),
                                                    controller.isLoadingRadius
                                                            .isFalse
                                                        ? controller.isRadius
                                                                .isFalse
                                                            ? const Text(
                                                                'Anda Diluar Radius',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        1.0,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            : const Text(
                                                                'Anda Didalam Radius ',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        1.0,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                        : const CircularProgressIndicator(),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Tombol Absen Masuk dan Absen Keluar
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              // Absen Masuk
                                              Container(
                                                height: 170,
                                                width: 165,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        offset: Offset(1, 2),
                                                        blurRadius: 6,
                                                        color:
                                                            Color(0x1A000000))
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                            blurRadius: 6.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (controller
                                                              .isAbsenMasuk
                                                              .isFalse) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CaptureView(),
                                                              ),
                                                            );
                                                          } else {
                                                            showToast(
                                                                message:
                                                                    "Anda Sudah Absen Masuk");
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              56,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Ink.image(
                                                          image: const AssetImage(
                                                              'assets/masuk.png'),
                                                          width: 35.0,
                                                          height: 35.0,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Text(
                                                      controller.isAbsenMasuk
                                                              .isFalse
                                                          ? 'Absen Masuk'
                                                          : 'Sudah Absen',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Absen Keluar
                                              Container(
                                                height: 170,
                                                width: 165,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        offset: Offset(1, 2),
                                                        blurRadius: 6,
                                                        color:
                                                            Color(0x1A000000))
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 70,
                                                        width: 70,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset: Offset(
                                                                  0.0, 2.0),
                                                              blurRadius: 6.0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CaptureView(),
                                                              ),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                56,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Ink.image(
                                                            image: const AssetImage(
                                                                'assets/keluar.png'),
                                                            width: 35.0,
                                                            height: 35.0,
                                                          ),
                                                        )),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    const Text(
                                                      'Absen Keluar',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: controller.dataAbsen.length,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final item =
                                            controller.dataAbsen[index];
                                        return item_riwayat_absen(
                                          item.tglPresensi != null
                                              ? DateFormat('d MMMM y ', 'id_ID')
                                                  .format(item.tglPresensi!)
                                              : 'Tanggal Presensi Tidak Tersedia',
                                          item.jamMasuk.toString(),
                                          item.jamPulang.toString(),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                controller.isLoading.isTrue
                                    ? const CircularProgressIndicator()
                                    : Container()
                              ],
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  )
                ],
              ),
            ]),
          ),
        ));
  }

  Padding item_riwayat_absen(tgl, masuk, keluar) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.orange,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    tgl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  'Absen Masuk : $masuk',
                  // Output 'Juni 2023'
                  style: const TextStyle(
                    color: Colors.black, // Ubah warna teks menjadi merah
                    fontSize: 12, // Ubah ukuran teks menjadi 20
                  ),
                ),
                Text(
                  'Absen Keluar : $keluar',
                  // Output 'Juni 2023'
                  style: const TextStyle(
                    color: Colors.black, // Ubah warna teks menjadi merah
                    fontSize: 12, // Ubah ukuran teks menjadi 20
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
