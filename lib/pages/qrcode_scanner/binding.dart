import 'package:get/get.dart';

import 'controller.dart';

class QRCodeScannerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRCodeScannerController>(() => QRCodeScannerController());
  }
}
