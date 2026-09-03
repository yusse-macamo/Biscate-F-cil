import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';
import '../../nucleo/tema/tema_app.dart';

/// Tom semântico de uma [EtiquetaEstado].
enum TomEtiqueta { positivo, neutro, negativo }

/// Etiqueta compacta para o estado de algo (um interesse, um pedido).
/// Cross-feature — vive em `comum/` porque mais do que uma pista precisa
/// dela. O texto diz sempre qual é o estado; a cor só reforça.
class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({super.key, required this.texto, required this.tom});

  final String texto;
  final TomEtiqueta tom;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final superficies = SuperficiesApp.de(context);

    final (Color fundo, Color cor) = switch (tom) {
      TomEtiqueta.positivo => (
          tema.colorScheme.primaryContainer,
          tema.colorScheme.onPrimaryContainer,
        ),
      TomEtiqueta.neutro => (superficies.alternativa, superficies.tintaFraca),
      TomEtiqueta.negativo => (
          superficies.alternativa,
          tema.colorScheme.onSurfaceVariant,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensoes.espaco8,
        vertical: Dimensoes.espaco4,
      ),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
      ),
      child: Text(texto, style: tema.textTheme.bodySmall?.copyWith(color: cor)),
    );
  }
}
