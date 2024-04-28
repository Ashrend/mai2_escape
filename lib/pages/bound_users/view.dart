import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../models/user.dart';
import 'controller.dart';

class BoundUsersPage extends GetView<BoundUsersController> {
  const BoundUsersPage({super.key});

  Widget _buildBindUserDialog() {
    return Obx(
      () => AlertDialog(
        title: const Text('绑定用户'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.qrCodeController,
              decoration: const InputDecoration(
                labelText: '二维码',
                hintText: '请输入二维码解码后的内容',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: controller.binding
                ? null
                : () {
                    controller.qrCodeController.clear();
                    Get.back();
                  },
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: controller.binding
                ? null
                : () {
                    controller.binding = true;
                    controller.bindUser().then((value) {
                      controller.binding = false;
                      showToast(value.message);
                      controller.binding = false;
                      if (value.success) {
                        Get.back();
                      }
                    });
                  },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPreview(UserModel user) {
    return InkWell(
      onTap: () {
        Get.dialog(SimpleDialog(
          clipBehavior: Clip.antiAlias,
          title: const Text("请选择操作"),
          children: [
            InkWell(
              onTap: () {
                Get.back();
                controller.logout(user.userId);
              },
              child: const ListTile(
                title: Text("逃离小黑屋"),
                leading: Icon(Icons.logout),
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
                controller.unbindUser(user.userId);
              },
              child: const ListTile(
                title: Text("解除绑定"),
                leading: Icon(Icons.delete),
              ),
            ),
          ],
        ));
      },
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colorScheme.secondaryContainer,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.person,
            size: 24,
          ),
        ),
        title: Text(user.userName),
        subtitle: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:
                    Get.theme.colorScheme.secondaryContainer.withOpacity(0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: Text(user.playerRating.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return EasyRefresh.builder(
      childBuilder: (context, physics) {
        return Obx(() {
          if (controller.boundUsers.isEmpty) {
            return CustomScrollView(
              physics: physics,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('暂无绑定用户'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            physics: physics,
            itemCount: controller.boundUsers.length,
            itemBuilder: (context, index) {
              return _buildUserPreview(controller.boundUsers[index]);
            },
          );
        });
      },
      onRefresh: controller.refreshData,
      header: const MaterialHeader(),
      footer: const ClassicFooter(
        dragText: "下拉刷新",
        armedText: "松开刷新",
        readyText: "正在刷新...",
        processingText: "正在刷新...",
        processedText: "刷新成功",
        noMoreText: "没有更多了",
        failedText: "刷新失败",
        messageText: "最后更新于 %T",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绑定的用户'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.dialog(_buildBindUserDialog());
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
