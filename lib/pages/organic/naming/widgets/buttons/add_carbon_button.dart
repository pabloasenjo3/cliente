import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class AddCarbonButton extends StatelessWidget {
  const AddCarbonButton({
    Key? key,
    required this.height,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: height,
      enabled: enabled,
      onPressed: onPressed,
      color: const Color.fromARGB(255, 56, 133, 224),
      child: Image.asset(
        'assets/images/icons/bond-carbon.png',
        color: QuimifyColors.inverseText(context),
        width: 26,
      ),
    );
  }
}
