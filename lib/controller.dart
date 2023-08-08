import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller {
  static final Controller _instance = Controller._();
  factory Controller() => _instance;
  Controller._();

  final ValueNotifier<Set<String>> _paths = ValueNotifier({});
  Set<String> get paths => _paths.value;

  final ValueNotifier<List<Directory>> foldersState = ValueNotifier([]);
  List<Directory> get folders => foldersState.value;

  Future<void> loadPathsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('paths') ?? [];
    _paths.value = paths.toSet();
    await loadFolders();
  }

  Future<void> addPath() async {
    final path = await getDirectoryPath();
    if (path == null) return;
    if (_paths.value.contains(path)) return;
    _paths.value.add(path);
    await savePathsToStorage();
    await loadFolders();
  }

  Future<void> removePath(String path) async {
    _paths.value.remove(path);
    await savePathsToStorage();
    await loadFolders();
  }

  Future<void> savePathsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('paths', _paths.value.toList());
  }

  Future<void> loadFolders() async {
    final folders = <Directory>[];
    for (var path in _paths.value) {
      final directory = Directory(path);
      if (await directory.exists()) {
        final entities = await directory.list().toList();
        final subfolders = entities.whereType<Directory>().toList();
        folders.addAll(subfolders);
      }
    }
    foldersState.value = folders;
  }
}
