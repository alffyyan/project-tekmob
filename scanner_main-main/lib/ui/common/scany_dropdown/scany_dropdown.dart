import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scanner_main/main.dart';

class ScanyDropdown extends StatelessWidget {
  const ScanyDropdown({
    Key? key,
    required this.labelText,
    this.iconData,
    this.svgAsset,
    required this.items,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  final String labelText;
  final IconData? iconData;
  final String? svgAsset;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      style: $styles.text.bodyTextLargeRegular.copyWith(
        color: $styles.colors.supportingExampleText
      ),
      decoration: InputDecoration(
        hintText: labelText,
        contentPadding:
            const EdgeInsets.only(left: 20.0, bottom: 15.0, top: 15.0),
        prefixIcon: iconData != null
            ? Icon(iconData)
            : svgAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      svgAsset!,
                      width: 24,
                      height: 24,
                    ),
                  )
                : null,
        filled: true,
        fillColor: $styles.colors.supportingBackground,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: $styles.colors.supportingBackground, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: $styles.colors.supportingBackground, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      items: items,
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down),
      dropdownColor: $styles.colors.supportingBackground,
    );
  }
}
