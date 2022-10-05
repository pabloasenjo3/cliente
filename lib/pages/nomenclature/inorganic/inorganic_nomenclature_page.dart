import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/api/api.dart';
import 'package:cliente/api/results/inorganic_result.dart';
import 'package:cliente/pages/nomenclature/widgets/quimify_search_bar.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/pages/widgets/quimify_teal.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/pages/widgets/quimify_dialog.dart';
import 'package:cliente/pages/widgets/quimify_loading.dart';
import 'package:cliente/pages/widgets/quimify_page_bar.dart';
import 'package:cliente/pages/nomenclature/widgets/quimify_icon_button.dart';
import 'package:flutter/material.dart';

class InorganicNomenclaturePage extends StatefulWidget {
  const InorganicNomenclaturePage({Key? key}) : super(key: key);

  @override
  State<InorganicNomenclaturePage> createState() =>
      _InorganicNomenclaturePageState();
}

class _InorganicNomenclaturePageState extends State<InorganicNomenclaturePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  String _labelText = 'NaCl, óxido de hierro...';

  final List<InorganicResultView> _results = [
    InorganicResultView(
      query: 'NaCl',
      inorganicResult: InorganicResult(
        true,
        false,
        'NaCl',
        'cloruro de sodio',
        'monocloruro de sodio',
        '58.44',
        '2.16',
        '1074.15',
        '1686.15',
        null,
        null,
      ),
    ),
  ];

  Future<void> _search(String input, bool photo) async {
    if (!isEmptyWithBlanks(input)) {
      startLoading(context);

      InorganicResult? result =
          await Api().getInorganic(toDigits(input), photo);

      stopLoading();

      if (result != null) {
        if (result.present) {
          setState(
            () => _results.add(
              InorganicResultView(
                query: input,
                inorganicResult: result,
              ),
            ),
          );

          // UI/UX actions:

          _labelText = input; // Sets previous input as label
          _textController.clear(); // Clears input
          _textFocusNode.unfocus(); // Hides keyboard

          _scrollToStart(); // Goes to the top of the page
        } else {
          if (!mounted) return; // For security reasons
          QuimifyDialog.reportableMessage(
            title: 'Sin resultado',
            details: 'No se ha encontrado:\n"$input"',
          ).show(context);
        }
      } else {
        // Client already reported an error in this case
        if (!mounted) return; // For security reasons
        QuimifyDialog.message(
          title: 'Sin resultado',
          details: 'No se ha encontrado:\n"$input"',
        ).show(context);
      }
    }
  }

  void _scrollToStart() {
    // Goes to the top of the page after a delay:
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopLoading();
        return true;
      },
      child: GestureDetector(
        onTap: () => _textFocusNode.unfocus(),
        child: QuimifyScaffold(
          header: Column(
            children: [
              const QuimifyPageBar(title: 'Formulación inorgánica'),
              QuimifySearchBar(
                label: _labelText,
                controller: _textController,
                focusNode: _textFocusNode,
                corrector: formatInorganicFormulaOrName,
                onSubmitted: (input) => _search(input, false),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 25,
              left: 25,
              right: 25,
            ),
            child: Wrap(
              verticalDirection: VerticalDirection.up,
              runSpacing: 25,
              children: _results,
            ),
          ),
        ),
      ),
    );
  }
}

class InorganicResultView extends StatefulWidget {
  const InorganicResultView(
      {Key? key, required this.query, required this.inorganicResult})
      : super(key: key);

  final String query;
  final InorganicResult inorganicResult;

  @override
  State<InorganicResultView> createState() => _InorganicResultViewState();
}

class _InorganicResultViewState extends State<InorganicResultView> {
  final AutoSizeGroup _quantityTitleAutoSizeGroup = AutoSizeGroup();

  late bool _isCollapsed = true;
  late List<InorganicResultField> _quantities;

  @override
  Widget build(BuildContext context) {
    _quantities = [
      if (widget.inorganicResult.mass != null)
        InorganicResultField(
          title: 'Masa',
          quantity: widget.inorganicResult.mass!,
          unit: 'g/mol',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.density != null)
        InorganicResultField(
          title: 'Densidad',
          quantity: widget.inorganicResult.density!,
          unit: 'g/cm³',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.meltingPoint != null)
        InorganicResultField(
          title: 'P. de fusión',
          quantity: widget.inorganicResult.meltingPoint!,
          unit: 'K',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.boilingPoint != null)
        InorganicResultField(
          title: 'P. de ebullición',
          quantity: widget.inorganicResult.boilingPoint!,
          unit: 'K',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
    ];

    return GestureDetector(
      onTap: () => setState(() => _isCollapsed = !_isCollapsed),
      child: Column(
        children: [
          // Head: (Result of: ...)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  'Búsqueda: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    maxLines: 1,
                    minFontSize: 12,
                    stepGranularity: 0.1,
                    widget.query,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Separator:
          const SizedBox(height: 2),
          // Body:,
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            padding:
                const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    toSubscripts(widget.inorganicResult.formula!),
                    style: const TextStyle(
                      color: quimifyTeal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.inorganicResult.name!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (widget.inorganicResult.synonym != null) ...[
                  const SizedBox(height: 2.5),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'o ${widget.inorganicResult.synonym!}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                AnimatedSize(
                  duration: Duration(milliseconds: _isCollapsed ? 150 : 300),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: _isCollapsed ? 0 : null,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        if (_quantities.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: _quantities[0],
                                    ),
                                    if (_quantities.length > 1) ...[
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 50,
                                        child: _quantities[1],
                                      ),
                                    ],
                                  ],
                                ),
                                if (_quantities.length > 2) ...[
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: _quantities[2],
                                      ),
                                      if (_quantities.length > 3) ...[
                                        const SizedBox(width: 20),
                                        Expanded(
                                          flex: 50,
                                          child: _quantities[3],
                                        ),
                                      ],
                                    ],
                                  )
                                ],
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: QuimifyIconButton(
                                height: 50,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/images/icons/report.png',
                                  color: Theme.of(context).colorScheme.onError,
                                  width: 18,
                                ),
                                text: Text(
                                  'Reportar',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: QuimifyIconButton(
                                height: 50,
                                onPressed: () {},
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  size: 18,
                                ),
                                text: Text(
                                  'Compartir',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RotatedBox(
                    quarterTurns: _isCollapsed ? 2 : 0,
                    child: Image.asset(
                      'assets/images/icons/narrow-arrow.png',
                      color: const Color.fromARGB(255, 189, 189, 189),
                      width: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InorganicResultField extends StatelessWidget {
  const InorganicResultField(
      {Key? key,
      required this.title,
      required this.quantity,
      required this.unit,
      required this.titleAutoSizeGroup})
      : super(key: key);

  final String title, quantity, unit;
  final AutoSizeGroup titleAutoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          maxLines: 1,
          stepGranularity: 0.1,
          group: titleAutoSizeGroup,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          '$quantity $unit',
          maxLines: 1,
          stepGranularity: 0.1,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
