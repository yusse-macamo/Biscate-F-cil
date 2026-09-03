import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Barra fixa no fundo com a acção principal ao alcance do polegar.
/// Sobe com o teclado e respeita a área segura do aparelho.
class BarraAccoes extends StatelessWidget {
  const BarraAccoes({super.key, required this.principal, this.secundaria});

  final Widget principal;
  final Widget? secundaria;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: esquema.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimensoes.margemEcra,
            Dimensoes.espaco12,
            Dimensoes.margemEcra,
            Dimensoes.espaco12,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Dimensoes.larguraMaximaConteudo,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  principal,
                  if (secundaria != null) ...[
                    const SizedBox(height: Dimensoes.espaco4),
                    secundaria!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
