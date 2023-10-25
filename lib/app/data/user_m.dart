// To parse this JSON data, do
//
//     final userM = userMFromJson(jsonString);

import 'dart:convert';

UserM userMFromJson(String str) => UserM.fromJson(json.decode(str));

String userMToJson(UserM data) => json.encode(data.toJson());

class UserM {
  String? message;
  String? accessToken;
  String? tokenType;
  User? user;

  UserM({
    this.message,
    this.accessToken,
    this.tokenType,
    this.user,
  });

  factory UserM.fromJson(Map<String, dynamic> json) => UserM(
        message: json["message"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "access_token": accessToken,
        "token_type": tokenType,
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  String? email;
  String? foto;
  dynamic emailVerifiedAt;
  String? nip;
  String? jabatan;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.foto,
    this.emailVerifiedAt,
    this.nip,
    this.jabatan,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        foto: json["foto"],
        emailVerifiedAt: json["email_verified_at"],
        nip: json["nip"],
        jabatan: json["jabatan"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "foto": foto,
        "email_verified_at": emailVerifiedAt,
        "nip": nip,
        "jabatan": jabatan,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
