import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class SaveAsCsv {
    Future<void> saveCSV({required List<List<String>> dataValue,required String fileName}) async {
    Directory? directory;
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final androidInfo = await deviceInfoPlugin.androidInfo;
        if (androidInfo.version.sdkInt > 29 &&
            await externalStoragePermission()) {
          String newPath = "";
          if (kDebugMode) {
            print(directory);
          }
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          newPath = "$newPath/Table_Plus";
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = "${directory.path}/$fileName.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          // successMsg();
        } else if (androidInfo.version.sdkInt < 30) {
          directory = Directory(directory!.path);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = "${directory.path}/$fileName.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          // successMsg();
        }
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
        directory = Directory(directory.path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        File saveFile = File("${directory.path}/$fileName");
        String csv = const ListToCsvConverter().convert(dataValue);
        saveFile.writeAsString(csv);
        await ImageGallerySaver.saveFile(saveFile.path,
            isReturnPathOfIOS: true);
        // successMsg();
      }
    } else if (kIsWeb) {
      String csv = const ListToCsvConverter(fieldDelimiter: ';').convert(dataValue);
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '$fileName.csv';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.Url.revokeObjectUrl(url);
      // successMsg();
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }


  Future<bool> externalStoragePermission() async {
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    return status1.isGranted;
  }


}