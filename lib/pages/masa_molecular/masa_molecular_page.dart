import 'package:flutter/material.dart';

import '../../widgets/home_app_bar.dart';
import '../../constants.dart';

class MasaMolecularPage extends StatelessWidget {
  const MasaMolecularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              HomeAppBar(
                title: Text(
                  'Masa molecular',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: bodyBoxDecoration,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
