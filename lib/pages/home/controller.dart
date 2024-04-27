import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class HomeController extends GetxController {
  DateTime? _lastPressedAt;
  TextEditingController qrCodeController = TextEditingController();

  void onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      _lastPressedAt = DateTime.now();
      showToast("再按一次退出");
      return;
    }
    SystemNavigator.pop();
  }
}
