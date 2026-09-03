import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Linha de escolha única. Substitui o rádio clássico, pequeno demais
/// para dedos com luvas.
class LinhaOpcao extends StatelessWidget {
  const LinhaOpcao({
    super.key,
    required this.titulo,
    this.descricao,
    this.icone,
    required this.seleccionada,
    required this.aoTocar,
  });

  final String titulo;
  final String? descricao;
  final IconData? icone;
  final bool seleccionada;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Semantics(
      selected: seleccionada,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(Dimensoes.espaco16),
            decoration: BoxDecoration(
              color: seleccionada
                  ? tema.colorScheme.primaryContainer
                  : tema.colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
              border: Border.all(
                color: seleccionada
                    ? tema.colorScheme.primary
                    : tema.colorScheme.outline,
                width: seleccionada ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (icone != null) ...[
                  Icon(icone, color: tema.colorScheme.primary),
                  const SizedBox(width: Dimensoes.espaco12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: tema.textTheme.titleSmall),
                      if (descricao != null)
                        Text(descricao!, style: tema.textTheme.bodySmall),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: seleccionada ? 1 : 0,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: tema.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
