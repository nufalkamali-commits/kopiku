import 'package:flutter/material.dart';
import 'utilitas/tema_warna.dart';
import 'layar/otentikasi/login.dart';

void main() {
  runApp(const KopiKitaApp());
}

class KopiKitaApp extends StatelessWidget {
  const KopiKitaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KopiKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: TemaWarna.emasKopi,
        scaffoldBackgroundColor: TemaWarna.latarGelap,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TemaWarna.emasKopi,
          brightness: Brightness.dark,
          surface: TemaWarna.kartuGelap,
        ),
        useMaterial3: true,
      ),
      home: const HalamanLogin(),
    );
  }
}
