import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/pages/widgets/objects/sign_in_button.dart';
import 'package:quimify_client/pages/widgets/particle_effect.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.clientResult});
  final ClientResult? clientResult;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QuimifyColors.background(context),
      body: Stack(
        children: [
          const ParticleEffect(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Center(
                child: Image.asset(
                  'assets/images/logo-branding.png',
                  width: 120,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: QuimifyColors.tertiary(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Accede a Quimify',
                    style: TextStyle(
                      fontSize: 20,
                      color: QuimifyColors.primary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: QuimifyColors.tertiary(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              SignInButton(
                onPressed: () async {
                  try {
                    _isGoogleLoading = true;
                    final user = await AuthService().signInWithGoogle();
                    if (user != null && context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(
                            clientResult: widget.clientResult,
                          ),
                        ),
                      );
                    }

                    _isGoogleLoading = false;
                  } catch (e) {
                    _isGoogleLoading = false;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Error al iniciar sesión con Google'),
                      ));
                    }
                  }
                },
                isLoading: _isGoogleLoading,
                label: 'Continúa con Google',
                icon: Image.asset(
                  'assets/images/icons/google-icon.png',
                  width: 24,
                ),
              ),
              if (Platform.isIOS) ...[
                const SizedBox(
                  height: 8,
                ),
                SignInButton(
                  onPressed: () async {
                    _isAppleLoading = true;
                    try {
                      final authService = AuthService();
                      final user = await authService.signInWithApple();
                      if (user != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(
                              clientResult: widget.clientResult,
                            ),
                          ),
                        );
                      }

                      _isAppleLoading = false;
                    } catch (e) {
                      _isAppleLoading = false;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Error al iniciar sesión con Apple'),
                        ));
                      }
                    }
                  },
                  isLoading: _isAppleLoading,
                  label: 'Iniciar sesión con Apple',
                  icon: Image.asset(
                    'assets/images/icons/apple-icon.png',
                    width: 24,
                  ),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: QuimifyColors.secondaryTeal(context),
                    ),
                    onPressed: () {
                      // Set skip login to true
                      AuthService().setSkipLogin(true);

                      // Navigate to home
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(
                            clientResult: widget.clientResult,
                          ),
                        ),
                      );
                    },
                    icon: Text(
                      'Omitir',
                      style: TextStyle(
                        color: QuimifyColors.secondaryTeal(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    label: Image.asset(
                      'assets/images/icons/arrow-forward.png',
                      width: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          )
        ],
      ),
    );
  }
}
