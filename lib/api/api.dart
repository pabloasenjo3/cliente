import 'dart:convert';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quimify_client/api/results/access_result.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client = http.Client();

  static const _apiVersion = 1;
  static const _clientVersion = 1;
  static const _authority = 'api.quimify.com';

  static final Map _urlToResponse = <String, String>{};

  Future<String?> _getResponse(String path, Map<String, dynamic> params) async {
    String? response;

    try {
      Uri url = Uri.https(_authority, 'v$_apiVersion/$path', params);

      // Looks it up in runtime cache:
      if (_urlToResponse.containsKey(url.toString())) {
        return _urlToResponse[url.toString()];
      }

      // It's a new query in this session:
      http.Response httpResponse = await _client.get(url);

      if (httpResponse.statusCode == 200) {
        response = utf8.decode(httpResponse.bodyBytes);
      } else {
        // Server bug or invalid URL:
        sendReport(
          label: 'HTTP código ${httpResponse.statusCode}',
          details: url.toString(),
        );
      }

      // If reached, it could at least connect to the API:
      _urlToResponse[url.toString()] = response; // New entry
    } catch (_) {} // No Internet connection, server down or client error.

    return response;
  }

  Future<AccessResult?> getAccess() async {
    AccessResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getResponse(
      'cliente',
      {
        'version': _clientVersion.toString(),
        'plataforma': platform.toString(),
      },
    );

    if (response != null) {
      try {
        result = AccessResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<void> sendReport({required String label, String? details}) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/reporte',
      {
        'version': _clientVersion.toString(),
        'titulo': label,
        'detalles': details,
      },
    );

    await _client.post(url);
  }

  Future<String?> getInorcanicCompletion(String input) =>
      _getResponse('inorganico/autocompletar', {'input': input});

  Future<InorganicResult?> getInorganicFromCompletion(String completion) async {
    InorganicResult? result;

    String? response = await _getResponse(
      'inorganico/autocompletar/buscar',
      {
        'complecion': completion,
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool photo) async {
    InorganicResult? result;

    String? response = await _getResponse(
      'inorganico',
      {
        'input': input,
        'foto': photo.toString(),
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getResponse(
      'masamolecular',
      {
        'formula': formula,
      },
    );

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<OrganicResult?> getOrganicByName(String name, bool picture) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/name',
      {
        'name': name,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<OrganicResult?> getOrganic(List<int> structureSequence) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/structure',
      {
        'structure-sequence': structureSequence.join(','),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
