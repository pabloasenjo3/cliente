import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class OrganicResultField extends StatelessWidget {
  const OrganicResultField({
    Key? key,
    required this.title,
    required this.field,
  }) : super(key: key);

  final String title, field;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
          strutStyle: const StrutStyle(
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AutoSizeText(
            field,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontFamily: 'CeraProBoldCustom',
            ),
            strutStyle: const StrutStyle(
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
