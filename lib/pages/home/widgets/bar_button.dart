import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.title,
    required this.selected,
    required this.autoSizeGroup,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final bool selected;
  final AutoSizeGroup autoSizeGroup;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: selected ? quimifyGradient : null,
        ),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          child: AutoSizeText(
            title,
            maxLines: 1,
            maxFontSize: 14,
            minFontSize: 12,
            stepGranularity: 0.1,
            group: autoSizeGroup,
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
