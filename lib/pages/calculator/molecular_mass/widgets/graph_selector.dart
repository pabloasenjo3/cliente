import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_bar.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_quantity.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_symbol.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_switch.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/text.dart';

class GraphSelector extends StatefulWidget {
  const GraphSelector({
    Key? key,
    required this.mass,
    required this.elementToGrams,
    required this.elementToMoles,
  }) : super(key: key);

  final num mass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;

  @override
  State<GraphSelector> createState() => _GraphSelectorState();
}

class _GraphSelectorState extends State<GraphSelector> {
  bool _molesGraph = false;

  _tappedGraph() => setState(() => _molesGraph = !_molesGraph);

  _pressedSwitch(bool newValue) => setState(() => _molesGraph = newValue);

  @override
  Widget build(BuildContext context) {
    List<GraphSymbol> symbols = [];

    List<GraphBar> gramBars = [];
    List<GraphNumber> gramQuantities = [];

    widget.elementToGrams.forEach((symbol, grams) {
      symbols.add(GraphSymbol(symbol: symbol));
      gramBars.add(GraphBar(quantity: grams, total: widget.mass));
      gramQuantities.add(GraphNumber(text: '${formatMolecularMass(grams)} g'));
    });

    String formula = '';

    List<GraphBar> molBars = [];
    List<GraphNumber> molQuantities = [];

    int totalMoles = widget.elementToMoles.values.reduce((sum, i) => sum + i);
    widget.elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
      molBars.add(GraphBar(quantity: moles, total: totalMoles));
      molQuantities.add(GraphNumber(text: '$moles mol'));
    });

    return GestureDetector(
      onTap: _tappedGraph,
      child: Container(
        decoration: BoxDecoration(
          color: QuimifyColors.chartBackground(context),
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
                    minFontSize: 18,
                    overflowReplacement: Text(
                      'Proporciones',
                      maxLines: 1,
                      style: TextStyle(
                        color: QuimifyColors.teal(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    stepGranularity: 0.1,
                    maxLines: 1,
                    style: TextStyle(
                      color: QuimifyColors.teal(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                QuimifySwitch(
                  value: _molesGraph,
                  onChanged: _pressedSwitch,
                ),
                Text(
                  'Pasar a mol',
                  style: TextStyle(
                    color: _molesGraph
                        ? QuimifyColors.teal()
                        : QuimifyColors.tertiary(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            IndexedStack(
              index: _molesGraph ? 1 : 0,
              children: [
                Graph(
                  symbols: symbols,
                  bars: gramBars,
                  quantities: gramQuantities,
                ),
                Graph(
                  symbols: symbols,
                  bars: molBars,
                  quantities: molQuantities,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
