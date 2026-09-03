import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Barra fixa no fundo do ecrã, com a acção principal ao alcance do
/// polegar.
class BarraAccoes extends StatelessWidget {
  const BarraAccoes({super.key, required this.principal, this.secundaria});

  final Widget principal;
  final Widget? secundaria;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tema.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: tema.colorScheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensoes.espaco20,
            vertical: Dimensoes.espaco12,
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Dimensoes.larguraMaximaConteudo),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  principal,
                  if (secundaria != null) ...[
                    const SizedBox(height: Dimensoes.espaco8),
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
