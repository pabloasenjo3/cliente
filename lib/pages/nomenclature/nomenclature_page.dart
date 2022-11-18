import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/inorganic_nomenclature_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/naming_open_chain_page.dart';
import 'package:quimify_client/pages/nomenclature/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/nomenclature/widgets/organic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_home_bar.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class NomenclaturePage extends StatelessWidget {
  NomenclaturePage({Key? key}) : super(key: key);

  final double cardWidth = 220;
  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyHomeBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QuimifySectionTitle(
                title: 'Inorgánica',
                dialog: InorganicHelpDialog(),
              ),
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Wrap(
                    spacing: 15,
                    children: [
                      QuimifyCard(
                        width: cardWidth,
                        title: 'Formular y nombrar',
                        structure: 'H₂O',
                        autoSizeGroup: autoSizeGroup,
                        name: 'óxido de hidrógeno',
                        page: const InorganicNomenclaturePage(),
                      ),
                      QuimifyCard.comingSoon(
                        width: cardWidth,
                        title: 'Practicar',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const QuimifySectionTitle(
                title: 'Orgánica',
                dialog: OrganicHelpDialog(),
              ),
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Wrap(
                    spacing: 15,
                    children: [
                      QuimifyCard.custom(
                        width: cardWidth,
                        title: 'Formular',
                        customBody: Container(
                          color: Theme.of(context).colorScheme.surface,
                          padding: const EdgeInsets.only(
                            top: 17 - 2,
                            bottom: 13 + 2,
                            left: 20,
                            right: 20,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/icons/2-chloroethylbenzene.png',
                                color: quimifyTeal,
                                height: 30,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '2-cloroetilbenceno',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        page: const FindingFormulaPage(),
                      ),
                      QuimifyCard(
                        width: cardWidth,
                        title: 'Nombrar',
                        structure: 'CH₂ = CH(OH)',
                        autoSizeGroup: autoSizeGroup,
                        name: 'etenol',
                        page: const NamingOpenChainPage(),
                      ),
                      QuimifyCard.comingSoon(
                        width: cardWidth,
                        title: 'Practicar',
                      ),
                    ],
                  ),
                ),
              ),
              // To keep it above navigation bar:
              const SizedBox(height: 2 * 30 + 60),
            ],
          ),
        ),
      ),
    );
  }
}
