import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../local/history.dart';
import '../../pages/widgets/popups/quimify_loading.dart';
import '../../pages/widgets/popups/quimify_message_dialog.dart';
import '../../pages/widgets/popups/quimify_no_internet_dialog.dart';
import '../../utils/internet.dart';
import '../api.dart';

class MolecularMassResult {
  final bool present;
  final String? formula;
  final num? molecularMass;
  final Map<String, num>? elementToGrams;
  final Map<String, int>? elementToMoles;
  final String? error;

  MolecularMassResult(
    this.present,
    this.formula,
    this.molecularMass,
    this.elementToGrams,
    this.elementToMoles,
    this.error,
  );

  factory MolecularMassResult.fromJson(String body, String formula) {
    dynamic json = jsonDecode(body);
    return MolecularMassResult(
      json['present'] as bool,
      formula, // TODO get it from API + null check
      json['molecularMass'] as num?,
      json['elementToGrams']?.cast<String, num>(),
      json['elementToMoles']?.cast<String, int>(),
      json['error'] as String?,
    );
  }
}
