import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/access_result.dart';
import 'package:quimify_client/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  // Show splash screen UNTIL stated otherwise:
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Loading:
  await Api().connect();
  AccessResult? accessResult = await Api().getAccess();

  // App launch:
  runApp(QuimifyApp(accessResult: accessResult));
}

class QuimifyApp extends StatelessWidget {
  const QuimifyApp({Key? key, this.accessResult}) : super(key: key);

  final AccessResult? accessResult;

  @override
  Widget build(BuildContext context) {
    // Hide splash screen:
    FlutterNativeSplash.remove();

    // To get rid of status bar's tint:
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: MaterialApp(
        title: 'Quimify',
        // To get rid of debug banner:
        debugShowCheckedModeBanner: false,
        // To set stretched scroll on all Android versions:
        scrollBehavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        // To ignore device's font scaling factor:
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        // Themes:
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'CeraPro',
          colorScheme: const ColorScheme(
            brightness: Brightness.light,

            primary: Color.fromARGB(255, 34, 34, 34),
            secondary: Colors.black12,
            tertiary: Colors.black45,

            surface: Colors.white,
            background: Color.fromARGB(255, 247, 247, 247),

            onPrimary: Colors.white, // White text
            onPrimaryContainer:
                Color.fromARGB(255, 240, 240, 240), // Unselected text

            onBackground: Color.fromARGB(255, 231, 246, 247),
            // Graph background
            onSecondary: Color.fromARGB(13, 0, 0, 0),
            // Graph bar background
            onSurface: Color.fromARGB(255, 241, 253, 250),
            // Inorganic amounts

            shadow: Color.fromARGB(25, 0, 0, 0),
            // Dialog barrier
            inverseSurface: Color.fromARGB(255, 60, 60, 60),
            // Lock icon

            onError: Color.fromARGB(255, 255, 96, 96),
            // Error text
            error: Color.fromARGB(255, 255, 241, 241),
            // Background
            onErrorContainer: Color.fromARGB(255, 56, 133, 224),
            // Share text
            errorContainer: Color.fromARGB(255, 239, 246, 253),
            // Background

            surfaceTint:
                Color.fromARGB(255, 255, 255, 255), // Diagram background

            onTertiaryContainer: Color.fromARGB(255, 106, 233, 218), // [<-]
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'CeraPro',
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,

            primary: Colors.white,
            secondary: Colors.white54,
            tertiary: Colors.white60,

            surface: Color.fromARGB(255, 30, 30, 30),
            background: Color.fromARGB(255, 18, 18, 18),

            onPrimary: Color.fromARGB(255, 18, 18, 18), // Black text
            onPrimaryContainer:
                Color.fromARGB(255, 90, 90, 90), // Unselected text

            onBackground: Color.fromARGB(255, 10, 38, 34),
            // Graph background
            onSecondary: Colors.black45,
            // Graph bar background
            onSurface: Color.fromARGB(255, 48, 170, 150),
            // Inorganic amounts

            shadow: Color.fromARGB(25, 255, 255, 255),
            // Dialog barrier
            inverseSurface: Color.fromARGB(255, 235, 235, 235),
            // Lock icon

            onError: Color.fromARGB(255, 18, 18, 18), // Black text
            // Error color
            error: Color.fromARGB(255, 255, 96, 96),
            // Background
            onErrorContainer: Color.fromARGB(255, 18, 18, 18), // Black text
            // Share color
            errorContainer: Color.fromARGB(255, 56, 133, 224),
            // Background

            surfaceTint: Color.fromARGB(255, 10, 10, 10), // Diagram background

            onTertiaryContainer: Color.fromARGB(255, 118, 252, 237), // [<-]
          ),
        ),
        // App:
        home: MainPage(accessResult: accessResult),
      ),
    );
  }
}
