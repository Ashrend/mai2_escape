import 'package:get/get.dart';

import '../bound_users/controller.dart';
import '../fast_logout/controller.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<FastLogoutController>(() => FastLogoutController());
    Get.lazyPut<BoundUsersController>(() => BoundUsersController());
  }
}
