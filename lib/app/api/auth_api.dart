import 'package:absen_dosen_mobile/utils/app_utils.dart';

import '../../service/api_service.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      const url = 'api/login';

      final response = await ApiService().request(
        url: url,
        method: Method.POST,
        parameters: {"email": username, "password": password},
        isToken: false,
      );
      logSys(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> whoiam() async {
    try {
      const url = 'api/whoiam';
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

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String name,
  }) async {
    try {
      const url = 'api/login';

      final response = await ApiService().request(
        url: url,
        method: Method.POST,
        parameters: {"email": username, "password": password, "name": name},
        isToken: false,
      );
      logSys(response.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
