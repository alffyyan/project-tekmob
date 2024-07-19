import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/ui/common/scany_button/scany_button.dart';
import 'package:scanner_main/ui/common/scany_outlined_button/scany_outline_button.dart';

class ScanyConfirmDialog {
  static show({
    required BuildContext context,
    required String title,
    String? body,
    String? text,
    String? okText,
    String? cancelText,
    required void Function() onOkPressed,
    void Function()? onCancelPressed,
    bool cancelable = true,
    String? assetPath,
  }) async {
    final cancelFunc = onCancelPressed ??
        () {
          context.pop();
        };
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) => _ScanyConfirmDialog(
            title: title,
            onOkPressed: onOkPressed,
            onCancelPressed: cancelFunc,
            okText: okText,
            body: body,
            cancelText: cancelText,
            cancelable: cancelable,
            assetPath: assetPath));
  }
}

class _ScanyConfirmDialog extends StatelessWidget {
  const _ScanyConfirmDialog({
    super.key,
    required this.title,
    this.body,
    this.okText,
    this.cancelText,
    required this.onOkPressed,
    required this.onCancelPressed,
    required this.cancelable,
    this.assetPath,
  });

  final String title;
  final String? body;
  final String? okText;
  final String? cancelText;
  final void Function() onOkPressed;
  final void Function() onCancelPressed;
  final bool cancelable;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: $styles.colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: assetPath != null
                  ? SvgPicture.asset(assetPath!)
                  : Image.asset('assets/images/vignettes/notif_success.png'),
            ),
            Text(
              title,
              style: $styles.text.bodyTextExtraLargeBold,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
              child: Text(
                body ?? '',
                textAlign: TextAlign.center,
                style: $styles.text.bodyTextSmall,
              ),
            ),
            Row(
              children: [
                cancelable
                    ? Expanded(
                        child: ScanyOutlinedButton(
                            horizontalPadding: 0,
                            verticalPadding: 18,
                            onPressed: onCancelPressed,
                            text: cancelText ?? "Cancel"),
                      )
                    : Container(),
                const SizedBox(width: 15),
                Expanded(
                  child: ScanyButton(
                    text: okText ?? "Yes",
                    onPressed: onOkPressed,
                    horizontalPadding: 0,
                    verticalPadding: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
