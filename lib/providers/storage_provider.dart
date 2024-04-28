import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../models/user.dart';

class GStorageList<T> {
  final GetStorage storage;
  final String key;
  final T Function(Map<String, dynamic> json) fact;
  final bool Function(T newItem, T oldItem)? compare;

  GStorageList(this.storage, this.key, this.fact, this.compare);

  List<T> get() {
    String? recordsJson = storage.read(key);
    return recordsJson == null
        ? []
        : (jsonDecode(recordsJson) as List<dynamic>)
            .where((item) => item != null)
            .map((item) => fact(item as Map<String, dynamic>))
            .toList();
  }

  T operator [](int index) => get()[index];

  Future<void> set(List<T> records) async {
    return await storage.write(key, jsonEncode(records));
  }

  Future<void> add(T newItem) async {
    List<T> records = get();
    if (records.isNotEmpty) {
      records.removeWhere((item) => compare!(newItem, item));
    }
    List<T> list = [newItem];
    list.addAll(records);
    await set(list);
  }

  Future<void> update(T oldItem, T newItem) async {
    List<T> list = get();
    int index = list.indexWhere((element) => element == oldItem);
    list[index] = newItem;
    await set(list);
  }

  Future<void> updateWhere(bool Function(T item) test, T newItem) async {
    List<T> list = get();
    int index = list.indexWhere(test);
    list[index] = newItem;
    await set(list);
  }

  Future<void> delete(T item) async {
    List<T> list = get();
    list.remove(item);
    await set(list);
  }

  Future<void> deleteWhere(bool Function(T item) test) async {
    List<T> list = get();
    list.removeWhere(test);
    await set(list);
  }

  Future<void> deleteByIndex(int index) async {
    List<T> list = get();
    list.removeAt(index);
    await set(list);
  }

  bool contains(T item) {
    List<T> list = get();
    return list.contains(item);
  }

  bool containsWhere(bool Function(T item) test) {
    List<T> list = get();
    return list.any(test);
  }

  Future<void> clean() async {
    await set([]);
  }

  T findWhere(bool Function(T item) test) {
    List<T> list = get();
    return list.firstWhere(test);
  }
}

class StorageProvider {
  static late GetStorage _storage;

  static Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  static GStorageList<UserModel> userList = GStorageList(
    _storage,
    "userList",
    UserModel.fromJson,
    (UserModel newItem, UserModel oldItem) => newItem.userId == oldItem.userId,
  );
}
