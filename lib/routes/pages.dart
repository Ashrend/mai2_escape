import 'package:get/get.dart';

import '../pages/home/binding.dart';
import '../pages/home/view.dart';

part './routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
