import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class GraphNumber extends StatelessWidget {
  const GraphNumber({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: QuimifyColors.primary(context),
        fontSize: 16,
      ),
    );
  }
}
