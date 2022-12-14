import 'package:flutter/material.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration functionalButtonBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Theme.of(context).colorScheme.tertiary,
        width: 1,
      ),
    );

    return QuimifySlidesDialog(
      titleToContent: {
        'Sustituyentes': [
          Container(
            decoration: functionalButtonBorder,
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/icons/single-bond.png',
                    color: Theme.of(context).colorScheme.primary,
                    width: 30,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'H',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Hidrógeno',
                  style: TextStyle(
                    color: quimifyTeal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.add,
                  color: quimifyTeal,
                  size: 22,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'En la lista aparecen los sustituyentes que se pueden '
                  'enlazar al carbono.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Text(
              'CH₃ –',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(carbono con tres hidrógenos)',
            ),
          ),
        ],
        'Radicales': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'Son ramificaciones de la cadena principal de carbonos.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/2-methylpropane.png',
              height: 90,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(2-metilpropano)',
            ),
          ),
        ],
        'Deshacer': [
          SizedBox(
            width: 100,
            child: Center(
              child: UndoButton(
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para deshacer el último cambio.',
            ),
          ),
        ],
        'Enlazar carbono': [
          SizedBox(
            width: 100,
            child: Center(
              child: AddCarbonButton(
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para añadir un carbono a la cadena.',
            ),
          ),
        ],
        'Hidrogenar': [
          SizedBox(
            width: 100,
            child: Center(
              child: SizedBox(
                child: HydrogenateButton(
                  enabled: true,
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para enlazar hidrógenos al carbono, '
                  'hasta que solo quede un enlace libre.',
            ),
          ),
        ],
      },
    );
  }
}
