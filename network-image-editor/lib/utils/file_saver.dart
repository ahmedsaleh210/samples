import 'dart:developer';
import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum SavedFileType { image, pdf }

abstract class FileSaver {
  Future<void> saveFile(Uint8List image);

  factory FileSaver(SavedFileType savedFileType) {
    switch (savedFileType) {
      case SavedFileType.image:
        return ImageSaver();
      case SavedFileType.pdf:
        return PDFSaver();
    }
  }
}

class ImageSaver implements FileSaver {
  @override
  Future<void> saveFile(Uint8List image) async {
    try {
      final result = await ImageGallerySaver.saveImage(image);
      log(result.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}

class PDFSaver implements FileSaver {
  final pw.Document pdf = pw.Document();

  @override
  Future<void> saveFile(Uint8List imageData) async {
    try {
      final image = pw.MemoryImage(imageData);
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
      await _savePDF(pdf);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _savePDF(pw.Document pdf) async {
    try {
      final String fileName = DateTime.now().toIso8601String();
      final dir = await getExternalStorageDirectory();
      final file =
          File('${dir?.path}/ "$fileName.pdf');
      final pdfBytes = await pdf.save();

      await file.writeAsBytes(pdfBytes.toList());
      DocumentFileSavePlus().saveMultipleFiles(
        dataList: [
          pdfBytes,
        ],
        fileNameList: [
          "$fileName.pdf",
        ],
        mimeTypeList: [
          "$fileName/pdf",
        ],
      );
      log('Test Pdf ${dir?.path}');
    } catch (e) {
      log(e.toString());
    }
  }
}
