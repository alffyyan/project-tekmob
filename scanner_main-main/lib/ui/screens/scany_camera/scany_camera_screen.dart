import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanyCameraScreen extends StatefulWidget {
  const ScanyCameraScreen({super.key});

  @override
  State<ScanyCameraScreen> createState() => _ScanyCameraScreenState();
}

class _ScanyCameraScreenState extends State<ScanyCameraScreen> {
  Offset? focusPoint;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  void _onTapFocusArea(TapDownDetails details) {
    setState(() {
      focusPoint = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        builder: (cameraState, preview) {
          return Stack(
            children: [
              GestureDetector(
                onTapDown: _onTapFocusArea,
              ),
              if (focusPoint != null)
                Positioned(
                  top: focusPoint!.dy - 25,
                  left: focusPoint!.dx - 25,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.yellow, width: 2),
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.flash_on, color: Colors.black),
                            onPressed: () {
                              // Handle flash button
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.black),
                            onPressed: () {
                              // Handle more options button
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/icons/camera/galeri_icon.svg',
                          ),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              final path = image.path;
                              Navigator.pop(context, File(path));
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 73,
                        height: 73,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 8,
                          onPressed: () async {
                            cameraState.when(onPhotoMode: (picState) async {
                              final file = await picState.takePhoto();
                              final path = file.path;
                              if (path != null) {
                                Navigator.pop(context, File(path));
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              'assets/images/icons/camera/camera_icon.svg',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/icons/camera/file_icon.svg',
                          ),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? file = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (file != null) {
                              final path = file.path;
                              Navigator.pop(context, File(path));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        saveConfig: SaveConfig.photo(),
        onPreviewTapBuilder: (state) => OnPreviewTap(
          onTap: (Offset position, PreviewSize flutterPreviewSize,
              PreviewSize pixelPreviewSize) {
            state.when(onPhotoMode: (picState) => picState.takePhoto());
          },
          onTapPainter: (tapPosition) => TweenAnimationBuilder(
            key: ValueKey(tapPosition),
            tween: Tween<double>(begin: 1.0, end: 0.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, anim, child) {
              return Transform.rotate(
                angle: anim * 2 * pi,
                child: Transform.scale(
                  scale: 4 * anim,
                  child: child,
                ),
              );
            },
            child: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
