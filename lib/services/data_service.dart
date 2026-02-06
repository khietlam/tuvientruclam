import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';

class DataService {
  static String? imagePath;
  static String? dataJsonPath;

  static Future<List<Person>> loadDataFromExternal() async {
    try {
      // First try to load from saved path if available
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString('dataPath');

      if (savedPath != null) {
        debugPrint("Loading data from saved path: $savedPath");
        return await _loadDataFromPath(savedPath);
      }

      // Try default external storage path
      final directory = await getExternalStorageDirectory();
      debugPrint("External storage path: ${directory?.path}");

      if (directory != null) {
        final file = File('${directory.path}/TuVienTrucLam/data.json');
        if (await file.exists()) {
          imagePath = '${directory.path}/TuVienTrucLam/images';
          dataJsonPath = file.path;

          final raw = await file.readAsString(encoding: utf8);
          final list = json.decode(raw) as List;
          return list.map((e) => Person.fromJson(e)).toList();
        }
      }

      // Try fallback path
      final fallbackFile = File(
        '/storage/emulated/0/Android/data/ca.truclam.tuvientruclam/files/TuVienTrucLam/data.json',
      );
      if (await fallbackFile.exists()) {
        imagePath =
            '/storage/emulated/0/Android/data/ca.truclam.tuvientruclam/files/TuVienTrucLam/images';
        dataJsonPath = fallbackFile.path;

        final raw = await fallbackFile.readAsString(encoding: utf8);
        final list = json.decode(raw) as List;
        return list.map((e) => Person.fromJson(e)).toList();
      }

      // If no data found, don't throw exception immediately
      // Let the main screen handle showing the folder selection
      debugPrint("No data.json found in any location");
      throw Exception("Không tìm thấy data.json");
    } catch (e) {
      debugPrint("Error in loadDataFromExternal: $e");
      throw Exception("Không tìm thấy data.json trong bất kỳ thư mục nào");
    }
  }

  static Future<List<Person>> _loadDataFromPath(String folderPath) async {
    try {
      final dataFile = File('$folderPath/data.json');
      final imagesPath = '$folderPath/images';

      debugPrint("Checking data file: ${dataFile.path}");

      if (!await dataFile.exists()) {
        throw Exception("Không tìm thấy file data.json trong thư mục đã chọn");
      }

      // Update paths for image loading
      imagePath = imagesPath;
      dataJsonPath = dataFile.path;

      debugPrint("Reading data file: ${dataFile.path}");
      final raw = await dataFile.readAsString(encoding: utf8);
      final list = json.decode(raw) as List;

      return list.map((e) => Person.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error in _loadDataFromPath: $e");
      throw Exception(
        "Lỗi khi tải dữ liệu từ thư mục đã chọn: ${e.toString()}",
      );
    }
  }

  static Future<String> selectDataFolder() async {
    try {
      // Let user select source directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Chọn thư mục chứa data.json và hình ảnh',
        lockParentWindow: true,
      );

      if (selectedDirectory == null) {
        throw Exception("Không có thư mục nào được chọn");
      }

      final sourceDir = Directory(selectedDirectory);
      debugPrint("Selected data directory: ${sourceDir.path}");

      if (!await sourceDir.exists()) {
        throw Exception("Thư mục được chọn không tồn tại");
      }

      // Check if data.json exists
      final dataFile = File('${sourceDir.path}/data.json');
      debugPrint("Looking for data.json at: ${dataFile.path}");

      if (!await dataFile.exists()) {
        // List directory contents to help debug
        try {
          final contents = await sourceDir.list().toList();
          debugPrint(
            "Directory contents: ${contents.map((e) => e.path).toList()}",
          );
        } catch (e) {
          debugPrint("Cannot list directory contents: $e");
        }
        throw Exception(
          "Không tìm thấy file data.json trong thư mục được chọn",
        );
      }

      // Save the selected path
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dataPath', sourceDir.path);

      // Update paths
      imagePath = '${sourceDir.path}/images';
      dataJsonPath = dataFile.path;

      return "Đã chọn thư mục dữ liệu thành công!\nĐường dẫn: ${sourceDir.path}";
    } catch (e) {
      debugPrint("Folder selection error: $e");
      throw Exception("Lỗi khi chọn thư mục: ${e.toString()}");
    }
  }

  static Future<void> clearSavedPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dataPath');
    imagePath = null;
    dataJsonPath = null;
  }
}
