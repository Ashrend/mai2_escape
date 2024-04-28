import 'package:get/get.dart';

import '../pages/home/binding.dart';
import '../pages/home/view.dart';
import '../pages/qrcode_scanner/binding.dart';
import '../pages/qrcode_scanner/view.dart';

part './routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.qrCodeScanner,
      page: () => const QRCodeScannerPage(),
      binding: QRCodeScannerBinding(),
    ),
  ];
}
