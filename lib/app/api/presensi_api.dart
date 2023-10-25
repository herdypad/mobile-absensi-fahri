import 'dart:io';

import '../../service/api_service.dart';

class PresensiApi {
  static Future<Map<String, dynamic>> riwayat(String id) async {
    try {
      final url = 'api/dataabsen/$id';
      final response = await ApiService().request(
        url: url,
        method: Method.GET,
        isToken: true,
      );
      // logSys(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> riwayatToday(String id) async {
    try {
      final url = 'api/dataabsentoday/$id';
      final response = await ApiService().request(
        url: url,
        method: Method.GET,
        isToken: true,
      );
      // logSys(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> clockin(String id, File file) async {
    try {
      final url = 'api/clockin';
      final response = await ApiService().request(
        url: url,
        method: Method.POST,
        parameters: {
          'user_id': id,
        },
        isToken: true,
      );
      // logSys(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
