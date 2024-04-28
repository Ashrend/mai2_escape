import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bound_users/view.dart';
import '../fast_logout/view.dart';
import 'controller.dart';

class TabPage {
  final String title;
  final IconData icon;
  final Widget page;

  TabPage(this.title, this.icon, this.page);
}

final List<TabPage> pages = [
  TabPage('快速逃离', Icons.directions_run, const FastLogoutPage()),
  TabPage('绑定的用户', Icons.people, const BoundUsersPage()),
];

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        controller.onBackPressed(context);
      },
      child: Scaffold(
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages.map((page) => page.page).toList(),
        ),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            destinations: pages
                .map((page) => NavigationDestination(
                      icon: Icon(page.icon),
                      label: page.title,
                    ))
                .toList(),
            selectedIndex: controller.pageIndex.value,
            onDestinationSelected: controller.onTabTapped,
          ),
        ),
      ),
    );
  }
}
