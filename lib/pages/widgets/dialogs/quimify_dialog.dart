import 'package:flutter/material.dart';

Future<void> showQuimifyDialog(
    Widget widget, bool closable, BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: closable,
    barrierColor: Theme.of(context).colorScheme.shadow,
    anchorPoint: const Offset(0, 0),
    // Centered
    builder: (BuildContext context) {
      return widget;
    },
  );
}

class QuimifyDialog extends StatelessWidget {
  const QuimifyDialog({
    super.key,
    required this.title,
    required this.hasCloseButton,
    required this.content,
    required this.action,
  });

  final String title;
  final bool hasCloseButton;
  final Widget? content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(25),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: hasCloseButton ? EdgeInsets.zero : null,
      title: Column(
        children: [
          if (hasCloseButton)
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                  padding:
                      const EdgeInsets.only(top: 17, right: 17, bottom: 10),
                ),
              ],
            ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 22,
            ),
          ),
        ],
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
      content: content,
      actionsPadding: const EdgeInsets.only(
        bottom: 20,
        left: 15,
        right: 15,
      ),
      actions: [
        action,
      ],
    );
  }
}
