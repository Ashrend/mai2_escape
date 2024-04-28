import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FastLogoutPage extends GetView<FastLogoutController> {
  const FastLogoutPage({super.key});

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
                      hintText: "请输入二维码解码后的内容",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      controller.logout(controller.qrCodeController.text);
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
          onPressed: () {},
          child: const Icon(Icons.qr_code),
        ));
  }
}
