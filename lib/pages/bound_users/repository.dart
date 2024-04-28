import 'dart:math';

import '../../common/group_result.dart';
import '../../models/user.dart';
import '../../providers/storage_provider.dart';

class BoundUsersRepository {
  BoundUsersRepository();

  GroupResult<UserModel> getUsers(int currentPage) {
    List<UserModel> users = [];

    users = StorageProvider.userList.get();

    var newData = users.getRange(
        currentPage * 16, min((currentPage + 1) * 16, users.length));

    return GroupResult(
      results: newData.toList(),
      count: users.length,
    );
  }
}
