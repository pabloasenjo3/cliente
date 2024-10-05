import 'package:flutter/material.dart';
import 'package:quimify_client/pages/home/home_page.dart';

import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/internet/api/sign-in/userAuthService.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class SignInPage extends StatelessWidget {
  final ClientResult? clientResult;

  static UserAuthService userAuthService = UserAuthService();

  const SignInPage({
    Key? key,
    this.clientResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QuimifyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.3,
                        maxWidth: constraints.maxWidth * 0.8,
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 175, // Set a fixed height for the image
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Google Sign-In button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final user = await UserAuthService().signInGoogleUser();
                        if (user == null) return;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                HomePage(clientResult: clientResult)));
                      },
                      icon: Image.asset('assets/images/icons/google-logo.png',
                          height: 24),
                      label: const Text('Iniciar Sesión con Google'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Anonymous Sign-In button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final user =
                            await UserAuthService().signInAnonymousUser();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                HomePage(clientResult: clientResult)));
                      },
                      icon: const Icon(Icons.person_off_outlined,
                          color: Colors.grey, size: 24),
                      label: const Text('Saltar'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Image.asset(
                      'assets/images/branding.png',
                      height: 25,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
