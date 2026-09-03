import 'package:flutter/material.dart';

import '../../../../nucleo/tema/dimensoes.dart';
import '../../../../nucleo/tema/tema_app.dart';
import '../../dominio/pedido.dart';

/// Etiqueta curta de urgência do pedido. Nunca só a cor a distinguir —
/// o texto diz sempre qual é.
class EtiquetaUrgencia extends StatelessWidget {
  const EtiquetaUrgencia({super.key, required this.urgencia});

  final Urgencia urgencia;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final superficies = SuperficiesApp.de(context);

    final (Color fundo, Color cor) = switch (urgencia) {
      Urgencia.hoje => (tema.colorScheme.errorContainer, tema.colorScheme.error),
      Urgencia.estaSemana => (
          tema.colorScheme.primaryContainer,
          tema.colorScheme.onPrimaryContainer,
        ),
      Urgencia.semPressa => (superficies.alternativa, superficies.tintaFraca),
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
      child: Text(
        urgencia.rotulo,
        style: tema.textTheme.bodySmall?.copyWith(color: cor),
      ),
    );
  }
}
