import 'package:flutter/material.dart';
import 'package:rest_api/screens/get_api.dart';
import 'package:rest_api/screens/put_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const GetApi());
  }
}
