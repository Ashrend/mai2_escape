import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../common/chime_error.dart';
import '../common/constants.dart';
import '../common/response.dart';

class ChimeProvider {
  static String hashData(String chipId, String timestamp) {
    return sha256
        .convert('$chipId$timestamp${AppConstants.chimeSalt}'.codeUnits)
        .toString()
        .toUpperCase();
  }

  static Future<CommonResponse<int>> getUserId({
    required String chipId,
    required String timestamp,
    required String qrCode,
  }) async {
    final data = jsonEncode({
      "chipID": chipId,
      "openGameID": AppConstants.gameID,
      "key": hashData(chipId, timestamp),
      "qrCode": qrCode,
      "timestamp": timestamp,
    });

    try {
      final client = HttpClient();

      final request = await client.postUrl(
        Uri.parse('http://${AppConstants.chimeHost}/wc_aime/api/get_data'),
      );

      request.headers.clear();
      request.headers
          .add('Host', AppConstants.chimeHost, preserveHeaderCase: true);
      request.headers
          .add('User-Agent', 'WC_AIME_LIB', preserveHeaderCase: true);
      request.headers.add('Content-Length', data.length.toString(),
          preserveHeaderCase: true);

      request.write(data);

      await request.flush();

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      final json = jsonDecode(responseBody);

      return CommonResponse(
        success: json['userID'] != -1,
        data: json['userID'],
        message: ChimeError(json['errorID']).toString(),
      );
    } catch (e) {
      return CommonResponse(
        success: false,
        data: -1,
        message: e.toString(),
      );
    }
  }
}
