import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'repository.dart';

class BoundUsersController extends GetxController {
  late EasyRefreshController refreshController;
  final BoundUsersRepository repository = BoundUsersRepository();

  final RxList _boundUsers = [].obs;
  List get boundUsers => _boundUsers;

  @override
  void onInit() {
    super.onInit();

    refreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
  }

  Future<void> refreshData(int state) async {
    int total = 0;
    int pageNum = 0;
    List<dynamic> users = [];

    while (users.length < total) {
      final result = repository.getUsers(pageNum);

      total = result.count;
      users.addAll(result.results);

      pageNum++;
    }

    if (users.isEmpty) {
      refreshController.finishRefresh(IndicatorResult.noMore);
      showToast("暂无数据");
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration callback) {
      _boundUsers.assignAll(users);
    });

    refreshController.finishRefresh(IndicatorResult.success);
  }
}
