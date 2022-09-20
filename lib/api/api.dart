import 'dart:convert';

import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/api/results/inorganic_result.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:http/http.dart' as http;

enum ApiPlatform { android, iOS, web }

class Api {
  factory Api() => _singleton;

  Api._internal();

  static final _singleton = Api._internal();
  final _client = http.Client();

  static const int _apiVersion = 0;
  static const String _authority = 'api.quimify.com';

  static const int _clientVersion = 0;

  Future<String?> _getResponse(String path, Map<String, dynamic> params) async {
    String? result;

    try {
      Uri url = Uri.https(_authority, 'v$_apiVersion/$path', params);
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

  Future<OrganicResult?> getOrganic(String name, bool photo) async {
    OrganicResult? result;

    String? response = await _getResponse(
        'organico/formular', {'nombre': name, 'foto': photo.toString()});

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool photo) async {
    InorganicResult? result;

    String? response = await _getResponse(
        'inorganico', {'input': input, 'foto': photo.toString()});

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

    String? response = await _getResponse('cliente', {
      'version': _clientVersion.toString(),
      'plataforma': platform.toString()
    });

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
