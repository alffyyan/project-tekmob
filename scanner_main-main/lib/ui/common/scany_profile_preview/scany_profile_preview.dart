import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scanner_main/main.dart';

class ScanyProfilePreview extends StatelessWidget {
  const ScanyProfilePreview({
    Key? key,
    required this.onPressed,
    this.imageUrl,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: $styles.colors.supportingBackground,
            borderRadius: const BorderRadius.all(Radius.circular(60)),
          ),
          child: CircleAvatar(
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            backgroundColor: Colors.transparent,
            radius: 40,
            child: imageUrl == null
                ? SvgPicture.asset(
              'assets/images/icons/profile/person_icon.svg',
              width: 58,
              height: 66,
            )
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: $styles.colors.primary,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: onPressed,
                iconSize: 15,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
