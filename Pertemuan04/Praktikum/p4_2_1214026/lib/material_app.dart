import 'package:flutter/material.dart';
import 'package:p4_2_1214026/material_page.dart';

class WitaApp extends StatefulWidget {
  const WitaApp({super.key});

  @override
  State<WitaApp> createState() => _WitaAppState();
}

class _WitaAppState extends State<WitaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: const MyCPage(),
    );
  }
}
