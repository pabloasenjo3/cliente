import 'package:cliente/pages/formulacion/pages/inorganica/formular_o_nombrar_page.dart';
import 'package:cliente/widgets/margined_column.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/widgets/margined_row.dart';
import 'package:cliente/widgets/constants.dart';

class FormulacionPage extends StatelessWidget {
  const FormulacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            HomeAppBar(
              title: Image.asset(
                'assets/images/icons/branding_slim.png',
                height: 17,
                color: Colors.white,
              ),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                width: double.infinity,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                // Vertically scrollable for short devices:
                child: SingleChildScrollView(
                  child: MarginedColumn.top(
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(title: 'Inorgánica'),
                        SizedBox(height: 25),
                        InorganicMenu(),
                        SizedBox(height: 40),
                        SectionTitle(title: 'Orgánica'),
                        SizedBox(height: 25),
                        OrganicMenu(),
                        // To keep it visible above navigation bar:
                        SizedBox(height: 50 + 60 + 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MarginedRow.center(
      margin: 25,
      child: Expanded(
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.help_outline),
              // To remove padding:
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class InorganicMenu extends StatelessWidget {
  const InorganicMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagesMenu(
      cards: [
        MenuCard(
          title: 'Formular o nombrar',
          structure: 'H₂O',
          name: 'dióxido de hidrógeno',
        ),
        MenuCard.custom(
          title: 'Practicar',
          locked: true,
        ),
      ],
    );
  }
}

class OrganicMenu extends StatelessWidget {
  const OrganicMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagesMenu(
      cards: [
        MenuCard.custom(
          title: 'Formular cualquiera',
          locked: false,
          customBody: MarginedColumn(
            top: 20,
            bottom: 15,
            child: MarginedRow.center(
              margin: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/icons/3-chloropropylbenzene.png',
                    color: quimifyTeal,
                    height: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '3-cloropropilbenceno',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        MenuCard(
          title: 'Nombrar simple',
          structure: 'CH₂ - CH₂(F)',
          name: '1-fluoroetano',
        ),
        MenuCard(
          title: 'Nombrar éter',
          structure: 'CH₃ - O - CH₃',
          name: 'dimetil éter',
        ),
        MenuCard.custom(
          title: 'Nombrar éster',
          locked: true,
        ),
        MenuCard.custom(
          title: 'Nombrar aromático',
          locked: true,
        ),
        MenuCard.custom(
          title: 'Nombrar cíclico',
          locked: true,
        ),
      ],
    );
  }
}

class PagesMenu extends StatelessWidget {
  const PagesMenu({Key? key, required this.cards}) : super(key: key);

  final List<MenuCard> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: MarginedRow(
        left: 25,
        right: 5,
        child: Row(
          children: cards,
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key? key,
      required this.title,
      this.locked,
      this.customBody,
      required this.structure,
      required this.name})
      : super(key: key);

  const MenuCard.custom(
      {Key? key,
      required this.title,
      required this.locked,
      this.customBody,
      this.structure,
      this.name})
      : super(key: key);

  final String title;

  final bool? locked;
  final Widget? customBody;

  final String? structure;
  final String? name;

  static Text _nameFor(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (structure != null)
      body = MarginedColumn.center(
        margin: 15,
        child: MarginedRow.center(
          margin: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                structure!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: quimifyTeal,
                ),
              ),
              SizedBox(height: 12),
              Text(
                name!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    else if (locked!)
      body = MarginedColumn.center(
        margin: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/icons/lock.png',
                height: 35,
                color: Color.fromARGB(255, 70, 70, 70),
              ),
            ),
            SizedBox(height: 12),
            Center(child: _nameFor('Próximamente')),
          ],
        ),
      );
    else
      body = customBody!;

    return Row(
      children: [
        InkWell(
          child: Container(
            width: 290,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            // To avoid rounded corners overflow:
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Container(
                  decoration: quimifyGradientBoxDecoration,
                  child: MarginedColumn(
                    top: 17,
                    bottom: 13,
                    child: MarginedRow.center(
                      margin: 25,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                body,
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const FormularONombrarPage();
                },
              ),
            );
          },
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
