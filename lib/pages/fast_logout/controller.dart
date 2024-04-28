import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/qr_code.dart';
import '../../components/loading_dialog/controller.dart';
import '../../components/loading_dialog/widget.dart';
import '../../providers/chime_provider.dart';
import '../../providers/mai2_provider.dart';

class FastLogoutController extends GetxController {
  TextEditingController qrCodeController = TextEditingController();

  void logout(String rawQrCode) async {
    ChimeQrCode qrCode = ChimeQrCode(rawQrCode);

    Get.dialog(
      LoadingDialog(
        task: () async {
          String message = "";

          if (!qrCode.isValid()) {
            return TaskResult(
              success: false,
              message: '无效的二维码',
            );
          }
          String chipId =
              "A63E-01E${Random().nextInt(999999999).toString().padLeft(8, '0')}";
          int userID = await ChimeProvider.getUserId(
            chipId: chipId,
            timestamp: qrCode.timestamp,
            qrCode: qrCode.qrCode,
          ).then((value) {
            if (value.success) {
              return value.data;
            } else {
              message = "获取用户ID失败：${value.message}";
              return -1;
            }
          });

          if (userID == -1) {
            return TaskResult(
              success: false,
              message: message,
            );
          }

          message = await Mai2Provider.logout(userID).then((value) {
            if (value.success) {
              return "逃离小黑屋成功：${value.message}";
            } else {
              return "逃离小黑屋失败：${value.message}";
            }
          });

          return TaskResult(
            success: true,
            message: message,
          );
        },
        onSuccess: () {},
      ),
      barrierDismissible: false,
    );
  }
}
