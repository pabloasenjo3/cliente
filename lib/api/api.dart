import 'dart:convert';

import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/api/results/inorganic_result.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:http/http.dart' as http;

class Api {
  factory Api() => _singleton;

  Api._internal();
  static final _singleton = Api._internal();
  final _client = http.Client();

  static const String _apiVersion = '0';
  static const String _authority = 'api.quimify.com:808$_apiVersion';

  static const int android = 0, iOS = 1, web = 2;

  Future<String?> _getResponse(
      String path, Map<String, dynamic> parameters) async {
    String? result;

    try {
      Uri url = Uri.http(_authority, path, parameters);
      http.Response response = await _client.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        result = body;
      } else {
        // Server crash or invalid URL
        // Error...
      }
    } catch (_) {
      // No internet, server down or client error
      // Error...
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool photo) async {
    InorganicResult? result;

    String? response = await _getResponse(
        'inorganico/', {'input': input, 'foto': photo.toString()});

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response =
        await _getResponse('masamolecular', {'formula': formula});

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<AccessResult?> connect(int platform) async {
    AccessResult? result;

    String? response =
        await _getResponse('bienvenida', {'plataforma': platform.toString()});

    if (response != null) {
      try {
        result = AccessResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
