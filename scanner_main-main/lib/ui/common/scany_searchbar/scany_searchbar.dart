import 'package:flutter/material.dart';

import '../../../main.dart';

class ScanySearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String hintText;

  const ScanySearchBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText = "Search",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: $styles.text.bodyTextLargeRegular.copyWith(
          color: $styles.colors.supportingGray,
        ),
        prefixIcon: Icon(
          Icons.search_outlined,
          color: $styles.colors.mainBlack,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: $styles.colors.supportingBackground,
      ),
    );
  }
}
