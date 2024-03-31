import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_mascot_message.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Diagram3DPage extends StatefulWidget {
  const Diagram3DPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<Diagram3DPage> createState() => _Diagram3DPageState();
}

enum _Result {
  successful,
  noInternet,
  unsupportedBrowser,
  error,
}

class _Diagram3DPageState extends State<Diagram3DPage> {
  final WebViewController _controller = WebViewController();

  _Result? _result;
  bool _pageError = false;

  bool? _lightMode;

  @override
  void initState() {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => request.url == widget.url
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
          onWebResourceError: (error) {
            _pageError = true;
            _onPageError(error);
          },
          onPageFinished: (_) {
            if (_pageError) return;
            _onPageFinished();
          },
        ),
      );

    _loadPage();
    super.initState();
  }

  _loadPage() async {
    await _controller.clearCache(); // Or else half-loaded pages will be shown
    _controller.loadRequest(Uri.parse(widget.url));
  }

  _reloadPage() {
    _pageError = false;

    setState(() {
      _result = null;
      _lightMode = null;
    });

    _loadPage();
  }

  // WebView will some times call both _onPageError and _onPageFinished

  _onPageError(WebResourceError error) async {
    if (_result != null) return;

    bool disconnected = error.description == 'net::ERR_INTERNET_DISCONNECTED';
    bool hasInternet = disconnected ? false : await hasInternetConnection();

    if (hasInternet) {
      Api().sendError(
        context: 'WebView error',
        details: 'URL "${widget.url}", device "${await _deviceName()}", '
            'error "${error.description}"',
      );
    }

    if (!mounted) return; // For security reasons
    setState(() {
      _result = hasInternet ? _Result.error : _Result.noInternet;
    });
  }

  _onPageFinished() async {
    if (_result != null) return;

    _Result result;

    try {
      result = await _adaptPage();

      if (result != _Result.successful) {
        Api().sendError(
          context: 'WebView adapt page failed',
          details: 'URL "${widget.url}", device "${await _deviceName()}"',
        );
      }
    } catch (error) {
      result = _Result.error;

      Api().sendError(
        context: 'WebView adapt page crashed',
        details: 'URL "${widget.url}", device "${await _deviceName()}", '
            'error "$error"',
      );
    }

    if (!mounted) return; // For security reasons
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lightMode == null) {
      // WebView's brightness mode can't be real-time
      Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
      _lightMode = platformBrightness == Brightness.light;
    }

    Color fromBackground = _lightMode! ? Colors.white : Colors.black;
    Color toBackground = QuimifyColors.background(context);
    List<double> backgroundFilter = _lightMode!
        ? [
            toBackground.red / fromBackground.red, 0, 0, 0, 0,
            0, toBackground.green / fromBackground.green, 0, 0, 0,
            0, 0, toBackground.blue / fromBackground.blue, 0, 0,
            0, 0, 0, 1, 0, // fromBackground -> toBackground, lineally
          ]
        : [
            1, 0, 0, 0, toBackground.red.toDouble(),
            0, 1, 0, 0, toBackground.green.toDouble(),
            0, 0, 1, 0, toBackground.blue.toDouble(),
            0, 0, 0, 1, 0, // fromBackground -> toBackground, not dividing by 0
          ];

    const String errorTitle = '¡Ups! No se ha podido cargar';
    final Map<_Result, QuimifyMascotMessage> resultToQuimifyMascot = {
      _Result.noInternet: QuimifyMascotMessage(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Parece que no hay conexión a Internet.',
        buttonLabel: 'Reintentar',
        onButtonPressed: _reloadPage,
      ),
      _Result.unsupportedBrowser: QuimifyMascotMessage.withoutButton(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Puede que este dispositivo sea demasiado antiguo.',
      ),
      _Result.error: QuimifyMascotMessage(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Puedes probar a intentarlo otra vez.',
        buttonLabel: 'Reintentar',
        onButtonPressed: _reloadPage,
      ),
    };

    return QuimifyScaffold.noAd(
      header: const QuimifyPageBar(title: 'Estructura 3D'),
      body: Stack(
        children: [
          if (_result == null || _result == _Result.successful)
            ColorFiltered(
              colorFilter: ColorFilter.matrix(backgroundFilter),
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          if (_result == null)
            Container(
              color: QuimifyColors.background(context),
              child: Center(
                child: CircularProgressIndicator(
                  color: QuimifyColors.teal(),
                ),
              ),
            ),
          if (_result != null && _result != _Result.successful)
            // Column is needed
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: resultToQuimifyMascot[_result]!,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<_Result> _adaptPage() async {
    if (await _checkUnsupportedBrowser()) {
      return _Result.unsupportedBrowser;
    }

    await _defineWaitForElement();
    await _runZoomOutMolecule();
    await _runFocusOnMolecule();

    for (int i = 0; i < 10; i++) {
      if (await _checkDoneAdaptWebPage()) {
        await Future.delayed(const Duration(milliseconds: 500)); // To ensure
        return _Result.successful;
      }

      await Future.delayed(const Duration(milliseconds: 500)); // Delay
    }

    return _Result.error;
  }

  _runZoomOutMolecule() async {
    String zoomOutButtonSelector = 'button.pc-gray-button[title="Zoom out"]';
    int zoomOutTotalClicks = 6;

    await _controller.runJavaScript('''
      async function zoomOutMolecule() {
        const zoomOutButton = await waitForElement('$zoomOutButtonSelector');
        
        for (let i = 0; i < $zoomOutTotalClicks; i++) {
          setTimeout(function() {
            zoomOutButton.click();
          }, 0);
        }
      }
      
      zoomOutMolecule();
    ''');
  }

  _runFocusOnMolecule() async {
    String moleculeSelector = 'canvas.cursor-hand';

    await _controller.runJavaScript('''
      async function focusOnMolecule() {
        const molecule = await waitForElement('$moleculeSelector');
        
        molecule.style.height = '100vh';
        
        document.body.innerHTML = '';
        document.body.appendChild(molecule); 
      }
      
      focusOnMolecule();
    ''');
  }

  _defineWaitForElement() async {
    await _controller.runJavaScript('''
      async function waitForElement(selector) {
        return new Promise((resolve) => {
          const observer = new MutationObserver((mutations) => {
            for (const mutation of mutations) {
              if (mutation.type === 'childList') {
                const element = document.querySelector(selector);
                  
                if (element !== null) {
                  observer.disconnect();
                  resolve(element);
                }
              }
            }
          });
        
          observer.observe(document.body, {
            childList: true
          });
        });
      }
    ''');
  }

  Future<bool> _checkUnsupportedBrowser() async {
    String text = 'Apologies, we no longer support your browser...';

    String innerText = await _controller.runJavaScriptReturningResult('''
      document.body.innerText
    ''') as String;

    return innerText.contains(text);
  }

  Future<bool> _checkDoneAdaptWebPage() async {
    Object emptyInnerText = await _controller.runJavaScriptReturningResult('''
      document.body.innerText === ''
    ''');

    return emptyInnerText == true;
  }

  Future<String> _deviceName() async =>
      await (await DeviceInfoPlugin().deviceInfo).data['product'];
}
