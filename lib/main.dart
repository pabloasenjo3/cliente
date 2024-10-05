import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/pages/inorganic/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/naming_page.dart';
import 'package:quimify_client/pages/sign-in/sign_in_page.dart';
import 'package:quimify_client/routes.dart';
import 'package:quimify_client/storage/storage.dart';

import 'internet/api/sign-in/userAuthService.dart';

main() async {
  _showLoadingScreen();

  await UserAuthService().initialize();
  Ads().initialize(await Api().getClient());
  await Storage().initialize();

  ClientResult? clientResult = await Api().getClient();

  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (context) => QuimifyApp(
        clientResult: clientResult,
      ), // Wrap your app
    ),
  );

  _hideLoadingScreen();
}

_showLoadingScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
}

_hideLoadingScreen() => FlutterNativeSplash.remove();

class QuimifyApp extends StatelessWidget {
  QuimifyApp({
    Key? key,
    this.clientResult,
  }) : super(key: key);

  final ClientResult? clientResult;
  RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  @override
  Widget build(BuildContext context) {
    // To get rid of status bar's tint:
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        title: 'Quimify',
        home: UserAuthService.loginRequiered() != true
            ? HomePage(
                clientResult: clientResult,
              )
            : SignInPage(
                clientResult: clientResult,
              ),
        routes: {
          Routes.inorganicNomenclature: (context) => const NomenclaturePage(),
          Routes.organicNaming: (context) => const NamingPage(),
          Routes.organicFindingFormula: (context) => const FindingFormulaPage(),
          Routes.calculatorMolecularMass: (context) =>
              const MolecularMassPage(),
        },
        // To get rid of debug banner:
        debugShowCheckedModeBanner: false,
        // To ignore device's font scaling factor:
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            // To fix a single overscroll behavior across al platforms:
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                overscroll: false,
              ),
              child: child,
            ),
          );
        },
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
          fontFamily: 'CeraPro',
        ),
        darkTheme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          fontFamily: 'CeraPro',
        ),
      ),
    );
  }
}
