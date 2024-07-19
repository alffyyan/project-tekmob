import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../crop_image/image_crop_screen.dart';
import '../image_filter/image_filter_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  late File _imageFile;
  late double _rotationAngle;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile;
    _rotationAngle = 0.0;
  }

  void _rotateLeft() {
    setState(() {
      _rotationAngle -= 90;
    });
  }

  void _rotateRight() {
    setState(() {
      _rotationAngle += 90;
    });
  }

  Future<void> _cropImage() async {
    final File? croppedFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropScreen(imageFile: _imageFile),
      ),
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
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
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Transform.rotate(
                  angle: _rotationAngle * 3.141592653589793238 / 180,
                  child: Image.file(_imageFile),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/icons/preview/rotate_left_icon.svg'),
                        onPressed: _rotateLeft,
                      ),
                      const Text(
                        'Left',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/icons/preview/rotate_right_icon.svg'),
                        onPressed: _rotateRight,
                      ),
                      const Text(
                        'Right',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/icons/preview/magnetic_icon.svg',
                          color: Colors.black,
                        ),
                        onPressed: _cropImage,
                      ),
                      const Text(
                        'Magnetic Cut',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/icons/preview/all_icon.svg'),
                        onPressed: () {
                          // Handle full-screen option
                        },
                      ),
                      const Text(
                        'All',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageFilterScreen(imageFile: _imageFile),
                          ),
                        );
                      },
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
}
