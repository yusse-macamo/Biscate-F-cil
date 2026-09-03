import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Linha de escolha única, com marca de selecção e contorno reforçado quando
/// activa. Substitui o rádio clássico, que fica pequeno para dedos com luvas.
class LinhaOpcao extends StatelessWidget {
  const LinhaOpcao({
    super.key,
    required this.titulo,
    required this.seleccionada,
    required this.aoTocar,
    this.descricao,
    this.icone,
  });

  final String titulo;
  final String? descricao;
  final IconData? icone;
  final bool seleccionada;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    return Semantics(
      selected: seleccionada,
      button: true,
      child: Material(
        color: seleccionada ? esquema.primaryContainer : esquema.surface,
        borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensoes.espaco16,
              vertical: Dimensoes.espaco16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
              border: Border.all(
                color: seleccionada ? esquema.primary : esquema.outline,
                width: seleccionada ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (icone != null) ...[
                  Icon(
                    icone,
                    size: 22,
                    color: seleccionada ? esquema.primary : esquema.onSurface,
                  ),
                  const SizedBox(width: Dimensoes.espaco12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: texto.titleMedium),
                      if (descricao != null) ...[
                        const SizedBox(height: Dimensoes.espaco4),
                        Text(descricao!, style: texto.bodySmall),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Dimensoes.espaco12),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: seleccionada ? 1 : 0,
                  child: Icon(Icons.check_circle_rounded,
                      size: 22, color: esquema.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
