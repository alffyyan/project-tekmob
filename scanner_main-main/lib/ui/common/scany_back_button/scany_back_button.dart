import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';

class ScanyBackButton extends StatelessWidget {
  const ScanyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: $styles.colors.supportingBlueThin,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
      ),
    );
  }
}
