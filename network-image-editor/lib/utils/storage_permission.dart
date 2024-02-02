
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_image_editor/utils/dialog.dart';

import 'package:permission_handler/permission_handler.dart';
class PrmissionUtil {
  static List<Permission> androidPermissions = <Permission>[
    Permission.storage
  ];

  static List<Permission> iosPermissions = <Permission>[
    Permission.storage
  ];

  static Future<Map<Permission, PermissionStatus>> requestAll() async {
    if (Platform.isIOS) {
      return await iosPermissions.request();
    }
    return await androidPermissions.request();
  }

  static Future<Map<Permission, PermissionStatus>> request(
      Permission permission) async {
    final List<Permission> permissions = <Permission>[permission];
    return await permissions.request();
  }

  static bool isDenied(Map<Permission, PermissionStatus> result) {
    var isDenied = false;
    result.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        isDenied = true;
        return;
      }
    });
    return isDenied;
  }

  static void showDeniedDialog(BuildContext context) {
    HDialog.show(
        context: context,
        title: 'The app needs permission to continue',
        content: 'Please grant the permission in the settings page',
        options: <DialogAction>[
          DialogAction(text: 'Open Settings', onPressed: () => openAppSettings())
        ]);
  }

  static Future<bool> checkGranted(Permission permission) async {
    PermissionStatus storageStatus = await permission.status;
    if (storageStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}