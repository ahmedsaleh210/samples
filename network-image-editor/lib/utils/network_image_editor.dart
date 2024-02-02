import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:network_image_editor/utils/file_saver.dart';

class NetworkImageEditor {
  static BuildContext? _context;
  static SavedFileType? _savedFileType;
  static NetworkImageEditor? _instance;

  NetworkImageEditor._();

  factory NetworkImageEditor(BuildContext context) {
    _context = context;
    _instance ??= NetworkImageEditor._();
    return _instance!;
  }

  Future<Uint8List> _getBytes(String imageUrl) async {
    try {
      final Uri uri = Uri.parse(imageUrl);
      final ByteData data = await NetworkAssetBundle(uri).load(uri.toString());
      return data.buffer.asUint8List();
    } catch (e) {
      log('Error loading image: $e');
      rethrow;
    }
  }

  Future<Uint8List?> initialize(
      {required String imageUrl,
      SavedFileType? savedFileType = SavedFileType.image}) async {
    try {
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      final Uint8List image = await _getBytes(imageUrl);
      _savedFileType = savedFileType;
      EasyLoading.dismiss();
      final Uint8List? editedImage = await _navigateToEditScreen(image);
      if (editedImage != null) {
        await _writeToFile(editedImage);
        log('Image editing success');
        return editedImage;
      }
    } catch (e) {
      log('Error editing image: $e');
    }
    return null;
  }

  Future<Uint8List?> _navigateToEditScreen(Uint8List imageData) async {
    return await Navigator.push<Uint8List?>(
        _context!,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageData,
          ),
        ));
  }

  Future<void> _writeToFile(
    Uint8List image,
  ) async {
    try {
      final FileSaver fileSaver = FileSaver(_savedFileType!);
      await fileSaver.saveFile(image);
    } catch (e) {
      log('Error saving image: $e');
    }
  }
}
