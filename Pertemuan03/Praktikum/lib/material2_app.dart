import 'package:flutter/material.dart';
import 'package:flutter_application_1/material2_page.dart';

class AppMaterial2 extends StatelessWidget {
  const AppMaterial2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: const HomePage(),
    );
  }
}
