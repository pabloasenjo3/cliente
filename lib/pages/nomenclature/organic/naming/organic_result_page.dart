import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/pages/nomenclature/organic/widgets/organic_result_view.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/pages/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

class OrganicResultPage extends StatelessWidget {
  const OrganicResultPage({Key? key, required this.title, required this.result})
      : super(key: key);

  final String title;
  final OrganicResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            PageAppBar(title: title),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: OrganicResultView(
                  fields: {
                    if (result.name != null) 'Nombre:': result.name!,
                    if (result.mass != null)
                      'Masa molecular:': '${result.mass!} g/mol',
                    if (result.structure != null)
                      'Fórmula:': formatStructure(result.structure!),
                  },
                  imageProvider:
                      result.url2D != null ? NetworkImage(result.url2D!) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
