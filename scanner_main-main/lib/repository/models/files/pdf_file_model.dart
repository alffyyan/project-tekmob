import 'dart:io';

import 'package:flutter/widgets.dart';

class PdfFile {
  final File file;
  final DateTime creationDate;
  final ImageProvider thumbnail;
  final int qty;

  PdfFile({
    required this.file,
    required this.creationDate,
    required this.thumbnail,
    required this.qty
  });
}
