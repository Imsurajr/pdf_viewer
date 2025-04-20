import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PDFDocumentModel {
  String? _assetPath;
  String? _filePath;
  int totalPages = 0;
  int currentPage = 1;

  PDFDocumentModel({String? assetPath}) {
    _assetPath = assetPath;
  }

  String? get filePath => _filePath;
  String? get assetPath => _assetPath;

  // preparing PDF from assets for viewing
  Future<String?> prepareFromAsset() async {
    if (_assetPath == null) return null;

    try {
      // loading as bytes
      final ByteData data = await rootBundle.load(_assetPath!);
      final List<int> bytes = data.buffer.asUint8List();

      // getting a temporary directory to write the file to
      final Directory tempDir = await getTemporaryDirectory();

      // temp path necessary to avoid error no asset path found
      final String tempPath = '${tempDir.path}/temp_pdf.pdf';

      final file = File(tempPath);
      final dir = file.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // writing pdf data to file
      await file.writeAsBytes(bytes, flush: true);

      // storing and return the file path
      _filePath = tempPath;
      return _filePath;
    } catch (e) {
      throw Exception('Failed to load PDF: $e');
    }
  }
}
