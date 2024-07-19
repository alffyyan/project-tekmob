import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scanner_main/main.dart';

class ScanyTextField extends StatefulWidget {
  const ScanyTextField({
    Key? key,
    required this.labelText,
    this.iconData,
    this.svgAsset,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  final String labelText;
  final IconData? iconData;
  final TextEditingController controller;
  final String? svgAsset;
  final bool isPassword;

  @override
  _ScanyTextFieldState createState() => _ScanyTextFieldState();
}

class _ScanyTextFieldState extends State<ScanyTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: $styles.text.bodyTextLargeRegular.copyWith(
          color: $styles.colors.supportingExampleText,
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, bottom: 15.0, top: 15.0),
        prefixIcon: widget.iconData != null
            ? Icon(widget.iconData)
            : widget.svgAsset != null
            ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            widget.svgAsset!,
            width: 24,
            height: 24,
          ),
        )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined ,
            color: $styles.colors.primary,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
        filled: true,
        fillColor: $styles.colors.supportingBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: $styles.colors.supportingBackground, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: $styles.colors.supportingBackground, width: 0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: $styles.colors.mainBlack, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: $styles.colors.mainBlack, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
