import 'dart:convert';

import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/local/results/molecular_mass_local_result.dart';
import 'package:quimify_client/local/results/organic_local_result.dart';
import 'package:quimify_client/local/storage.dart';

class History {
  // Constants:

  // TODO: inorganic
  // TODO: test organic
  static const String _organicFormulasKey = 'organic-formulas';
  static const String _organicNamesKey = 'organic-names';
  static const String _molecularMassesKey = 'molecular-masses';

  // Private:

  static List<dynamic> _fetch(String key, Function(String) fromJson) {
    final String? data = Storage().get(key);

    if (data == null) {
      return [];
    }

    return jsonDecode(data).map((e) => fromJson(e)).toList();
  }

  static _save(String key, dynamic localResult, List<dynamic> localResults) {
    localResults.remove(localResult);
    localResults.insert(0, localResult);

    List<dynamic> data = localResults.map((e) => e.toJson()).toList();

    Storage().save(key, jsonEncode(data));
  }

  // Public:

  static List<OrganicLocalResult> getOrganicFormulas() =>
      _fetch(_organicFormulasKey, OrganicLocalResult.fromJson)
          .cast<OrganicLocalResult>();

  static saveOrganicFormula(OrganicResult result) => _save(
        _organicFormulasKey,
        OrganicLocalResult.fromResult(result),
        getOrganicFormulas(),
      );

  static List<OrganicLocalResult> getOrganicNames() =>
      _fetch(_organicNamesKey, OrganicLocalResult.fromJson)
          .cast<OrganicLocalResult>();

  static saveOrganicName(OrganicResult result) => _save(
        _organicNamesKey,
        OrganicLocalResult.fromResult(result),
        getOrganicNames(),
      );

  static List<MolecularMassLocalResult> getMolecularMasses() =>
      _fetch(_molecularMassesKey, MolecularMassLocalResult.fromJson)
          .cast<MolecularMassLocalResult>();

  static saveMolecularMass(MolecularMassResult result) => _save(
        _molecularMassesKey,
        MolecularMassLocalResult.fromResult(result),
        getMolecularMasses(),
      );
}
