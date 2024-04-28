import 'dart:collection';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../common/constants.dart';
import '../common/response.dart';
import '../models/user.dart';
import '../utils/http.dart';

class Mai2Provider {
  static LinkedHashMap<String, String> maiHeader =
      LinkedHashMap<String, String>.from({
    "Content-Type": "application/json",
    "User-Agent": "",
    "charset": "UTF-8",
    "Mai-Encoding": "1.30",
    "Content-Encoding": "deflate",
    "Content-Length": "",
    "Host": AppConstants.mai2Host,
  });

  static String obfuscate(String srcStr) {
    final m = md5.convert(('$srcStr${AppConstants.mai2Salt}').codeUnits);
    return m.toString();
  }

  static Uint8List aesEncrypt(String data) {
    final key = Key.fromUtf8(AppConstants.aesKey);
    final iv = IV.fromUtf8(AppConstants.aesIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    return encrypter.encrypt(data, iv: iv).bytes;
  }

  static String aesDecrypt(Uint8List data) {
    final key = Key.fromUtf8(AppConstants.aesKey);
    final iv = IV.fromUtf8(AppConstants.aesIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    return encrypter.decrypt(Encrypted(data), iv: iv);
  }

  static Future<CommonResponse<UserModel?>> getUserPreview({
    required int userID,
  }) async {
    final data = jsonEncode({
      'userId': userID,
    });
    final body = zlib.encode(aesEncrypt(data.toString()));

    maiHeader['User-Agent'] =
        "${obfuscate('GetUserPreviewApiMaimaiChn')}#$userID";
    maiHeader['Content-Length'] = body.length.toString();

    try {
      final client = HttpClient();

      final request = await client.postUrl(
        Uri.parse(
            'https://${AppConstants.mai2Host}/Maimai2Servlet/${obfuscate('GetUserPreviewApiMaimaiChn')}'),
      );

      request.headers.clear();
      for (final key in maiHeader.keys) {
        request.headers.add(key, maiHeader[key]!, preserveHeaderCase: true);
      }

      request.add(body);

      await request.flush();

      final response = await request.close();

      String message = "";
      bool success = false;
      UserModel? user;

      final responseBody = await response.toBytes();

      try {
        message = aesDecrypt(Uint8List.fromList(zlib.decode(responseBody)));
        final json = jsonDecode(message);
        if (json['userId'] == null || json['userName'] == null) {
          success = false;
          message = "用户为空，可能未注册";
        } else {
          user = UserModel.fromJson(json);
          success = true;
        }
      } catch (e) {
        success = false;
        message = utf8.decode(responseBody);
      }

      return CommonResponse(
        success: success,
        data: user,
        message: message,
      );
    } catch (e) {
      return CommonResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  static Future<CommonResponse<Null>> logout(int userId) async {
    final String userAgent = '${obfuscate('UserLogoutApiMaimaiChn')}#$userId';
    final String data = "{\"userId\":$userId}";

    final body = zlib.encode(aesEncrypt(data.toString()));

    maiHeader['User-Agent'] = userAgent;
    maiHeader['Content-Length'] = body.length.toString();
    try {
      final response = await Mai2HttpClient.post(
        Uri.parse(
            'https://${AppConstants.mai2Host}/Maimai2Servlet/${obfuscate('UserLogoutApiMaimaiChn')}'),
        maiHeader,
        body,
      );

      bool success = false;
      String message = "未知错误";

      if (response.body.isEmpty) {
        message = "服务器返回为空";
        success = false;
        return CommonResponse(success: success, message: message, data: null);
      }

      try {
        message = aesDecrypt(Uint8List.fromList(zlib.decode(response.body)));
        success = true;
      } catch (e) {
        success = false;
        message = utf8.decode(response.body);
      }

      return CommonResponse(success: success, message: message, data: null);
    } catch (e) {
      return CommonResponse(success: false, message: e.toString(), data: null);
    }
  }
}
