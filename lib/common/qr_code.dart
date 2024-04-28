import 'constants.dart';

class ChimeQrCode {
  final String rawQRCode;

  ChimeQrCode(this.rawQRCode);

  static bool isValid(String rawQRCode) {
    return rawQRCode.indexOf(AppConstants.wechatID) == 0 &&
        rawQRCode.indexOf(AppConstants.gameID) == 4;
  }

  bool get valid => isValid(rawQRCode);
  String get timestamp => rawQRCode.substring(8, 20);
  String get qrCode => rawQRCode.substring(20);
}
