import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import 'controller.dart';

class BoundUsersPage extends GetView<BoundUsersController> {
  const BoundUsersPage({super.key});

  Widget _buildUserPreview(UserModel user) {
    return ListTile(
      title: Text(user.userName),
      subtitle: Text("${user.playerRating ?? '未知'}"),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      ),
    );
  }

  Widget _buildBody() {
    return EasyRefresh.builder(
      childBuilder: (context, physics) {
        if (controller.boundUsers.isEmpty) {
          return const Center(
            child: Text('暂无绑定用户'),
          );
        }
        return ListView.builder(
          physics: physics,
          itemCount: controller.boundUsers.length,
          itemBuilder: (context, index) {
            return _buildUserPreview(controller.boundUsers[index]);
          },
        );
      },
      header: const ClassicHeader(
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
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
