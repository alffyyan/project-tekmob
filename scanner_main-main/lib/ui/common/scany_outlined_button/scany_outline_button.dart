import 'package:flutter/material.dart';
import 'package:scanner_main/main.dart';

class ScanyOutlinedButton extends StatelessWidget {
  const ScanyOutlinedButton(
      {Key? key,
      this.onPressed,
      this.text,
      this.horizontalPadding = 0,
      this.verticalPadding = 0,
      this.textStyle,
      this.icon,
      this.isSmall})
      : super(key: key);

  final void Function()? onPressed;
  final String? text;
  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool? isSmall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: SizedBox(
        width: isSmall == true ? 60 : MediaQuery.of(context).size.width,
        height: 56,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: 2.0,
                color: onPressed != null
                    ? $styles.colors.primary
                    : $styles.colors.supportingGray),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onPressed,
          child: icon != null
              ? SizedBox(
                  width: 20,
                  child: Icon(icon, color: $styles.colors.mainBlack),
                )
              : Text(
                  text ?? "Default Text",
                  style: onPressed != null
                      ? (textStyle ??
                          $styles.text.bodyTextLargeBold
                              .copyWith(color: $styles.colors.mainBlack))
                      : $styles.text.bodyTextLargeBold
                          .copyWith(color: $styles.colors.supportingGray),
                ),
        ),
      ),
    );
  }
}
