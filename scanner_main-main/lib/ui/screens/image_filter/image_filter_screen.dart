import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router.dart';

class ImageFilterScreen extends StatefulWidget {
  final File imageFile;

  const ImageFilterScreen({super.key, required this.imageFile});

  @override
  _ImageFilterScreenState createState() => _ImageFilterScreenState();
}

class _ImageFilterScreenState extends State<ImageFilterScreen> {
  late File _imageFile;
  late bool _isBlackAndWhite;
  late bool _isGrayscale;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile;
    _isBlackAndWhite = false;
    _isGrayscale = false;
  }

  void _applyFilter(String filter) {
    setState(() {
      if (filter == 'blackAndWhite') {
        _isBlackAndWhite = true;
        _isGrayscale = false;
      } else if (filter == 'grayscale') {
        _isBlackAndWhite = false;
        _isGrayscale = true;
      } else {
        _isBlackAndWhite = false;
        _isGrayscale = false;
      }
    });
  }

  ColorFilter get _currentFilter {
    if (_isBlackAndWhite) {
      return const ColorFilter.mode(Colors.grey, BlendMode.saturation);
    } else if (_isGrayscale) {
      return const ColorFilter.mode(Colors.grey, BlendMode.color);
    } else {
      return const ColorFilter.mode(Colors.transparent, BlendMode.saturation);
    }
  }

  void _navigateToNextScreen() {
    context.push(
      ScreenPaths.arrangeImage,
      extra: _imageFile,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ColorFiltered(
                colorFilter: _currentFilter,
                child: Image.file(_imageFile),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterPreview('Original', Colors.transparent, 'original'),
                  _buildFilterPreview('B&W', Colors.grey, 'blackAndWhite'),
                  _buildFilterPreview('Grayscale', Colors.grey.shade800, 'grayscale'),
                  _buildFilterPreview('Coming Soon', Colors.grey.shade800, 'grayscale'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      onPressed: _navigateToNextScreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPreview(String label, Color color, String filter) {
    return GestureDetector(
      onTap: () => _applyFilter(filter),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.saturation),
              child: Image.file(_imageFile, fit: BoxFit.cover),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
