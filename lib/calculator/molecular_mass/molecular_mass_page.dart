import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/text.dart';
import '../../widgets/constants.dart';
import '../../widgets/home_app_bar.dart';
import 'molecular_mass_result.dart';

class MolecularMassPage extends StatefulWidget {
  const MolecularMassPage({Key? key}) : super(key: key);

  @override
  State<MolecularMassPage> createState() => _MolecularMassPageState();
}

class _MolecularMassPageState extends State<MolecularMassPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  String _labelText = 'H₂SO₄';

  MolecularMassResult _result = MolecularMassResult(true, 97.96737971,
      {'H': 2.01588, 'S': 32.066, 'O': 63.976}, {'H': 2, 'S': 1, 'O': 4}, '');

  Future<void> _calculate(String input) async {
    if (input.isNotEmpty) {
      var url = Uri.http(
          '192.168.1.90:8080', 'masamolecular', {'formula': toDigits(input)});
      var response = await http.get(url);

      MolecularMassResult result =
          MolecularMassResult.fromJson(jsonDecode(response.body));

      setState(() {
        _result = result;
      });

      // UI/UX actions:

      _labelText = input; // Clears input
      _textController.clear(); // Sets previous input as label

      FocusManager.instance.primaryFocus?.unfocus(); // Hides keyboard

      // Goes to the end of the page:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // App bar:
            const HomeAppBar(
              title: Text(
                'Calculadora',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                // Vertically scrollable for short devices:
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fórmula',
                              style: subTitleStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              // Aspect:
                              cursorColor:
                                  const Color.fromARGB(255, 34, 34, 34),
                              style: inputOutputStyle,
                              keyboardType: TextInputType.visiblePassword,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 3),
                                isCollapsed: true,
                                labelText: _labelText,
                                labelStyle: const TextStyle(
                                  color: Colors.black12,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                // So hint doesn't go up while typing:
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: quimifyTeal.withOpacity(0.5)),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: quimifyTeal.withOpacity(0.5)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: quimifyTeal),
                                ),
                              ),
                              // Logic:
                              controller: _textController,
                              onChanged: (String input) {
                                _textController.value =
                                    _textController.value.copyWith(
                                  text: formatFormula(input),
                                );
                              },
                              textInputAction: TextInputAction.search,
                              onSubmitted: (input) => _calculate(input),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Output(mass: _result.mass),
                      const SizedBox(height: 25),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: quimifyGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox.expand(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () => _calculate(_textController.text),
                            child: const Text(
                              'Calcular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      GraphMenu(
                        mass: _result.mass,
                        elementToGrams: _result.elementToGrams,
                        elementToMoles: _result.elementToMoles,
                      ),
                      // To keep it above navigation bar:
                      const SizedBox(height: 50 + 60),
                    ],
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

const TextStyle subTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const TextStyle inputOutputStyle = TextStyle(
  color: quimifyTeal,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

class Output extends StatelessWidget {
  const Output({Key? key, required this.mass}) : super(key: key);

  final num mass;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Masa molecular',
            style: subTitleStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          AutoSizeText(
            '${mass.toStringAsFixed(3)} g/mol',
            stepGranularity: 0.1,
            maxLines: 1,
            style: inputOutputStyle,
          ),
        ],
      ),
    );
  }
}

class GraphMenu extends StatefulWidget {
  const GraphMenu(
      {Key? key,
      required this.mass,
      required this.elementToGrams,
      required this.elementToMoles})
      : super(key: key);

  final num mass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;

  @override
  State<GraphMenu> createState() => _GraphMenuState();
}

class _GraphMenuState extends State<GraphMenu> {
  bool _mol = false;

  @override
  Widget build(BuildContext context) {
    List<GraphSymbol> symbols = [];
    List<GraphBar> gramBars = [];
    List<GraphAmount> gramAmounts = [];

    widget.elementToGrams.forEach((symbol, grams) {
      symbols.add(GraphSymbol(symbol: symbol));
      gramBars.add(GraphBar(amount: grams, total: widget.mass));
      gramAmounts.add(GraphAmount(amount: '${grams.round()} g'));
    });

    String formula = '';
    List<GraphBar> molBars = [];
    List<GraphAmount> molAmounts = [];

    int totalMoles = widget.elementToMoles.values.reduce((sum, i) => sum + i);
    widget.elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
      molBars.add(GraphBar(amount: moles, total: totalMoles));
      molAmounts.add(GraphAmount(amount: '$moles mol'));
    });

    return Container(
      decoration: BoxDecoration(
        color: quimifyTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  toSubscripts(formula),
                  style: const TextStyle(
                    color: quimifyTeal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                activeColor: Colors.white,
                activeTrackColor: quimifyTeal,
                inactiveTrackColor: Colors.black12,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _mol,
                onChanged: (bool value) {
                  setState(() {
                    _mol = value;
                  });
                },
              ),
              Text(
                'Pasar a mol',
                style: TextStyle(
                  color: _mol ? quimifyTeal : Colors.black12,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          IndexedStack(
            index: _mol ? 1 : 0,
            children: [
              Graph(symbols: symbols, bars: gramBars, amounts: gramAmounts),
              Graph(symbols: symbols, bars: molBars, amounts: molAmounts),
            ],
          ),
        ],
      ),
    );
  }
}

class GraphSymbol extends StatelessWidget {
  const GraphSymbol({Key? key, required this.symbol}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class GraphBar extends StatelessWidget {
  const GraphBar({Key? key, required this.amount, required this.total})
      : super(key: key);

  final num amount, total;

  @override
  Widget build(BuildContext context) {
    double proportion = amount / total;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: FractionallySizedBox(
        widthFactor: min(proportion, 1),
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: quimifyTeal,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class GraphAmount extends StatelessWidget {
  const GraphAmount({Key? key, required this.amount}) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      amount,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class Graph extends StatelessWidget {
  const Graph(
      {Key? key,
      required this.symbols,
      required this.bars,
      required this.amounts})
      : super(key: key);

  final List<GraphSymbol> symbols;
  final List<GraphBar> bars;
  final List<GraphAmount> amounts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: symbols
              .map(
                (symbol) => Column(
                  children: [
                    symbol,
                    const SizedBox(height: 15),
                  ],
                ),
              )
              .toList(),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            children: bars
                .map(
                  (bar) => Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      children: [
                        bar,
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: amounts
              .map(
                (amount) => Column(
                  children: [
                    amount,
                    const SizedBox(height: 15),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
