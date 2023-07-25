import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';

class QuimifyHelpButton extends StatelessWidget {
  const QuimifyHelpButton({
    Key? key,
    required this.dialog,
  }) : super(key: key);

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Theme.of(context).colorScheme.primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // To remove padding:
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => showQuimifyDialog(context: context, dialog: dialog),
      icon: const Icon(Icons.help_outline, size: 26),
    );
  }
}
