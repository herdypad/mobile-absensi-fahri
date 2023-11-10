import 'package:http/http.dart' as http;

import '../../utils/app_utils.dart';

class ServiceFr {
  final TAG = 'ServiceFr';

  Future<dynamic> cekFace({
    required String filex,
    required String url,
    required String filex2,
  }) async {
    final Uri apiUrl = Uri.parse(url);
    final request = http.MultipartRequest('POST', apiUrl);

    // Tambahkan file foto
    final file = await http.MultipartFile.fromPath('file1', filex);
    final file2 = await http.MultipartFile.fromPath('file2', filex2);
    request.files.add(file);
    request.files.add(file2);

    // Kirim request
    final response = await request.send();

    // Log status code
    logSys(response.statusCode.toString());

    if (response.statusCode == 500) {
      return Future.error(
          'Gagal mengunggah file. Status Code: ${response.statusCode}');
    }

    // Handle response
    if (response.statusCode == 200) {
      // Read the response
      final responseString = await response.stream.bytesToString();
      logSys(responseString);
      return responseString;
    } else {
      // Mengembalikan pesan kesalahan jika gagal
      print('Gagal mengunggah file. Status Code: ${response.statusCode}');
      return Future.error(
          'Gagal mengunggah file. Status Code: ${response.statusCode}');
    }
  }
}
