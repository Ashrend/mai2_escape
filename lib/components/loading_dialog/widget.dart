import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoadingDialog extends GetWidget<LoadingDialogController> {
  final Future<TaskResult> Function() task;
  final Function()? onSuccess;
  final Function()? onFail;

  const LoadingDialog({
    super.key,
    required this.task,
    this.onSuccess,
    this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    controller.init(task);

    return controller.obx(
      (successMessage) => AlertDialog(
        title: const Text("逃离小黑屋成功"),
        content: Text(successMessage ?? "逃离小黑屋成功"),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onSuccess?.call();
            },
            child: const Text(
              "确定",
            ),
          )
        ],
      ),
      onLoading: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      child: const CircularProgressIndicator(),
                    ),
                    const Text("逃离小黑屋中..."),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onError: (error) => AlertDialog(
        title: const Text("逃离小黑屋失败"),
        content: Text(error ?? "未知错误"),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onFail?.call();
            },
            child: const Text(
              "确定",
            ),
          ),
        ],
      ),
    );
  }
}
