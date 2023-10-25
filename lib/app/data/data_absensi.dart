// To parse this JSON data, do
//
//     final dataAbsensiM = dataAbsensiMFromJson(jsonString);

import 'dart:convert';

DataAbsensiM dataAbsensiMFromJson(String str) =>
    DataAbsensiM.fromJson(json.decode(str));

String dataAbsensiMToJson(DataAbsensiM data) => json.encode(data.toJson());

class DataAbsensiM {
  int? id;
  int? userId;
  DateTime? tglPresensi;
  String? jamMasuk;
  dynamic jamPulang;
  String? fotoMasuk;
  String? fotoPulang;
  dynamic ket;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataAbsensiM({
    this.id,
    this.userId,
    this.tglPresensi,
    this.jamMasuk,
    this.jamPulang,
    this.fotoMasuk,
    this.fotoPulang,
    this.ket,
    this.createdAt,
    this.updatedAt,
  });

  factory DataAbsensiM.fromJson(Map<String, dynamic> json) => DataAbsensiM(
        id: json["id"],
        userId: json["user_id"],
        tglPresensi: json["tgl_presensi"] == null
            ? null
            : DateTime.parse(json["tgl_presensi"]),
        jamMasuk: json["jam_masuk"],
        jamPulang: json["jam_pulang"],
        fotoMasuk: json["foto_masuk"],
        fotoPulang: json["foto_pulang"],
        ket: json["ket"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "tgl_presensi":
            "${tglPresensi!.year.toString().padLeft(4, '0')}-${tglPresensi!.month.toString().padLeft(2, '0')}-${tglPresensi!.day.toString().padLeft(2, '0')}",
        "jam_masuk": jamMasuk,
        "jam_pulang": jamPulang,
        "foto_masuk": fotoMasuk,
        "foto_pulang": fotoPulang,
        "ket": ket,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
