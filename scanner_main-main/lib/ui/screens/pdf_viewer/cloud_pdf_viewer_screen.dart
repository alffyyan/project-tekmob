import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class CloudPdfViewerScreen extends StatefulWidget {
  final String downloadUrl;

  const CloudPdfViewerScreen({Key? key, required this.downloadUrl}) : super(key: key);

  @override
  _CloudPdfViewerScreenState createState() => _CloudPdfViewerScreenState();
}

class _CloudPdfViewerScreenState extends State<CloudPdfViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      // Get the temporary directory of the device
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/temp.pdf';

      // Download the PDF file
      final response = await Dio().download(widget.downloadUrl, tempFilePath);

      // Check if the file was downloaded successfully
      if (response.statusCode == 200) {
        setState(() {
          localFilePath = tempFilePath;
        });
      } else {
        // Handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (e) {
      // Handle the exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: localFilePath != null
          ? PDFView(
        filePath: localFilePath!,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
