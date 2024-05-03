import 'dart:convert';

class BalancerResult {
  final String? formula;
  final bool present;
  final String? originalEquation;
  final String? originalReactants;
  final String? originalProducts;
  final String? balancedEquation;
  final String? balancedReactants;
  final String? balancedProducts;
  final String? error;

  BalancerResult(
    this.formula,
    this.present,
    this.originalEquation,
    this.originalReactants,
    this.originalProducts,
    this.balancedEquation,
    this.balancedReactants,
    this.balancedProducts,
    this.error,
  );

  factory BalancerResult.fromJson(String body, String formula) {
    var json = jsonDecode(body);
    return BalancerResult(
      formula,
      json['present'],
      json['originalEquation'],
      json['originalReactants'],
      json['originalProducts'],
      json['balancedEquation'],
      json['balancedReactants'],
      json['balancedProducts'],
      json['error'],
    );
  }
}
