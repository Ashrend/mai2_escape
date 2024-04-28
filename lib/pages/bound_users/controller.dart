import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mai2_revive/providers/storage_provider.dart';
import 'package:oktoast/oktoast.dart';

import '../../common/qr_code.dart';
import '../../components/loading_dialog/controller.dart';
import '../../components/loading_dialog/widget.dart';
import '../../models/user.dart';
import '../../providers/chime_provider.dart';
import '../../providers/mai2_provider.dart';
import 'repository.dart';

class BoundUsersController extends GetxController {
  late EasyRefreshController refreshController;
  final BoundUsersRepository repository = BoundUsersRepository();

  TextEditingController qrCodeController = TextEditingController();

  final RxList _boundUsers = [].obs;
  List get boundUsers => _boundUsers;

  final RxBool _binding = false.obs;
  bool get binding => _binding.value;
  set binding(bool value) => _binding.value = value;

  @override
  void onInit() {
    super.onInit();

    refreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    refreshData();
  }

  Future<void> refreshData() async {
    int total = 16;
    int pageNum = 0;
    List<dynamic> users = [];

    boundUsers.clear();

    while (users.length < total) {
      final result = repository.getUsers(pageNum);

      total = result.count;
      users.addAll(result.results);

      pageNum++;
    }

    if (users.isEmpty) {
      refreshController.finishRefresh(IndicatorResult.noMore);
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration callback) {
      _boundUsers.assignAll(users);
    });

    refreshController.finishRefresh(IndicatorResult.success);
  }

  Future<TaskResult> bindUser() async {
    String rawQrCode = qrCodeController.text;
    ChimeQrCode qrCode = ChimeQrCode(rawQrCode);

    String message = "";

    if (!qrCode.valid) {
      message = '无效的二维码';
      return TaskResult(
        success: false,
        message: message,
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
      showToast(message);
      return TaskResult(
        success: false,
        message: message,
      );
    }

    UserModel user =
        await Mai2Provider.getUserPreview(userID: userID).then((value) {
      if (value.success) {
        return value.data!;
      } else {
        message = "获取用户信息失败：${value.message}";
        return UserModel(
          userId: -1,
          userName: "未知",
        );
      }
    });

    if (user.userId == -1) {
      showToast(message);
      return TaskResult(
        success: false,
        message: message,
      );
    }

    StorageProvider.userList.add(user);

    await refreshData();

    return TaskResult(
      success: true,
      message: "绑定用户成功：${user.userName}",
    );
  }

  void unbindUser(int userId) async {
    StorageProvider.userList.deleteWhere((item) => item.userId == userId);
    await refreshData();
  }

  void logout(int userId) async {
    Get.dialog(
      LoadingDialog(
        task: () async {
          String message = "";

          message = await Mai2Provider.logout(userId).then((value) {
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
