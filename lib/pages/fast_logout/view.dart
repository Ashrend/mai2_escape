import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/qr_code.dart';
import '../../components/loading_dialog/controller.dart';
import '../../components/loading_dialog/widget.dart';
import '../../providers/chime_provider.dart';
import '../../providers/mai2_provider.dart';
import 'controller.dart';

class FastLogoutPage extends GetView<FastLogoutController> {
  const FastLogoutPage({super.key});

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

          int userID = await ChimeProvider.getUserId(
            chipId: "A63E-01E12856414",
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

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: controller.qrCodeController,
                    decoration: const InputDecoration(
                      labelText: '二维码',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      logout(controller.qrCodeController.text);
                    },
                    child: const Text('逃离小黑屋'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mai批复活'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.qr_code),
      )
    );
  }
}
