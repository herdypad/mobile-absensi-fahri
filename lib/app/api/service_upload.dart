import 'package:http/http.dart' as http;

import '../../constants/constant.dart';
import '../../utils/app_storage.dart';
import '../../utils/app_utils.dart';

class ServiceUpload {
  final TAG = 'ServiceUpload';

  Future<dynamic> uploadFileAbsen(
      {required String filex, required String url, required String id}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${BASE_URL}${url}'), // Ganti dengan URL upload API Anda
    );

    final token = await AppStorage.read(key: CACHE_ACCESS_TOKEN);
    var headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };

    // Data parameter yang ingin Anda kirim
    final Map<String, String> data = {
      'user_id': id,
    };

    // Buat request
    request.headers.addAll(headers);

    // Tambahkan data parameter
    request.fields.addAll(data);

    // Tambahkan file foto
    final file = await http.MultipartFile.fromPath('file', filex);
    request.files.add(file);

    // Kirim request
    final response = await request.send();

    logSys(response.statusCode.toString());

    if (response.statusCode == 200) {
      // Read the response
      final responseString = await response.stream.bytesToString();
      logSys(responseString);
      return responseString;
    } else {
      print('Gagal mengunggah file.');
    }
  }
}
