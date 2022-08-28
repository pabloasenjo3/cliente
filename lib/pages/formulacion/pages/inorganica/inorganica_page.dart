import 'package:cliente/widgets/margined_column.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/margined_row.dart';
import 'package:cliente/widgets/search_bar.dart';
import 'package:cliente/constants.dart' as constants;

class InorganicaPage extends StatelessWidget {
  const InorganicaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: constants.quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              PageAppBar(title: 'Formulación inorgánica'),
              SearchBar(hint: 'NaCl, óxido de hierro...'),
              Expanded(
                child: Container(
                  decoration: constants.bodyBoxDecoration,
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  child: MarginedRow.center(
                    margin: 25,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: MarginedColumn.bottom(
                          bottom: 25,
                          child: SearchResults(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<SearchResult> results = [
    SearchResult(),
    SearchResult(),
    SearchResult(),
    SearchResult(),
    SearchResult(),
    SearchResult(),
    SearchResult(),
    SearchResult(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: results);
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarginedColumn(
      top: 25,
      bottom: 5,
      // Search result:
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: MarginedRow.center(
              margin: 15,
              child: MarginedColumn.center(
                margin: 15,
                child: Row(
                  children: [
                    Text(
                      'Búsqueda: ',
                      style: TextStyle(color: Colors.black38),
                    ),
                    Text('ácido sulfúrico'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: MarginedRow.center(
              margin: 20,
              child: MarginedColumn.center(
                margin: 20,
                child: Row(
                  children: [
                    Text('Result of: ', style: TextStyle(fontSize: 20)),
                    Text('ácido sulfúrico', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
