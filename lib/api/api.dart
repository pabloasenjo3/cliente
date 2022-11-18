import 'dart:convert';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quimify_client/api/results/access_result.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';

import 'env.dart';

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client;

  static const _apiVersion = 3;
  static const _clientVersion = 3;
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

  // Public:

  Future<void> connect() async {
    io.SecurityContext context = io.SecurityContext(withTrustedRoots: true);

    context.usePrivateKeyBytes(utf8.encode(
      '-----BEGIN PRIVATE KEY-----\n'
      '${Env.apiKey}'
      '\n-----END PRIVATE KEY-----\n',
    ));

    context.useCertificateChainBytes(utf8.encode(
      '-----BEGIN CERTIFICATE-----\n'
      '${Env.apiCertificate}'
      '\n-----END CERTIFICATE-----\n',
    ));

    _client = io.IOClient(io.HttpClient(context: context));
  }

  Future<AccessResult?> getAccess() async {
    AccessResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getResponse(
      'client/access-data',
      {
        'version': _clientVersion.toString(),
        'platform': platform.toString(),
      },
    );

    if (response != null) {
      try {
        result = AccessResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Access JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<void> sendReport({required String label, String? details}) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/report',
      {
        'client-version': _clientVersion.toString(),
        'title': label,
        'details': details,
      },
    );

    await _client.post(url);
  }

  Future<String?> getInorganicCompletion(String input) =>
      _getResponse('inorganic/completion', {'input': input});

  Future<InorganicResult?> getInorganicFromCompletion(String completion) async {
    InorganicResult? result;

    String? response = await _getResponse(
      'inorganic/from-completion',
      {
        'completion': completion,
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Inorganic from completion JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool picture) async {
    InorganicResult? result;

    String? response = await _getResponse(
      'inorganic',
      {
        'input': input,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Inorganic JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getResponse(
      'molecular-mass',
      {
        'formula': formula,
      },
    );

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Molecular mass JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganicFromName(String name, bool picture) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/from-name',
      {
        'name': name,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Organic from name JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganicFromStructure(List<int> sequence) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/from-structure',
      {
        'structure-sequence': sequence.join(','),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Organic from structure JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
