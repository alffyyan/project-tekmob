import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:flutter_svg/flutter_svg.dart';

import '../../../main.dart'; // Ensure you use Flutter SVG for SVG assets

class ScanyDatePicker extends StatefulWidget {
  const ScanyDatePicker({
    Key? key,
    required this.labelText,
    this.iconData,
    this.svgAsset,
    required this.controller,
  }) : super(key: key);

  final String labelText;
  final IconData? iconData;
  final TextEditingController controller;
  final String? svgAsset;

  @override
  _ScanyDatePickerState createState() => _ScanyDatePickerState();
}

class _ScanyDatePickerState extends State<ScanyDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    widget.controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: $styles.colors.primary, // Change primary color as needed
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.labelText,
            hintStyle: TextStyle(
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
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/images/icons/profile/calendar_icon.svg',
                width: 24,
                height: 24,
              ),
            ),
            filled: true,
            fillColor: $styles.colors.supportingBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: $styles.colors.supportingBackground,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
