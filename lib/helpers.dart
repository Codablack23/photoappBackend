import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class Helpers {
  static debugPrint(dynamic value) {
    if (kDebugMode) {
      print(value);
    }
  }
}

class FileDetail {
  final String name;
  final Uint8List file;

  FileDetail(this.name, this.file);
}
