import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'funcionalidades/prestador/apresentacao/ecras/cadastro_prestador_ecra.dart';
import 'nucleo/tema/tema_app.dart';

void main() {
  runApp(const ProviderScope(child: BiscateFacilApp()));
}

class BiscateFacilApp extends StatelessWidget {
  const BiscateFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscate Fácil',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      darkTheme: TemaApp.escuro,
      home: const CadastroPrestadorEcra(),
    );
  }
}
