import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'funcionalidades/prestador/apresentacao/ecras/cadastro_prestador_ecra.dart';
import 'nucleo/tema/tema_app.dart';

void main() => runApp(const ProviderScope(child: AppPrestador()));

class AppPrestador extends StatelessWidget {
  const AppPrestador({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prestador',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      darkTheme: TemaApp.escuro,
      themeMode: ThemeMode.system,
      home: const CadastroPrestadorEcra(),
    );
  }
}
