import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oktoast/oktoast.dart';

import '../../common/qr_code.dart';
import '../fast_logout/controller.dart';

class QRCodeScannerController extends GetxController {
  FastLogoutController fastLogoutController = Get.find<FastLogoutController>();

  void onQRCodeScanned(Barcode? barcode) {
    if (barcode != null && barcode.rawValue != null) {
      if (ChimeQrCode.isValid(barcode.rawValue!)) {
        fastLogoutController.qrCodeController.text = barcode.rawValue!;
        showToast('扫描成功');
        Get.back();
      } else {
        showToast('无效的二维码');
      }
    }
  }
}
