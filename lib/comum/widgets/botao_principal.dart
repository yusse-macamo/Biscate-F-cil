import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Botão principal de acção. O estilo (cor, altura, raio) vem do tema;
/// aqui só se decide o conteúdo.
class BotaoPrincipal extends StatelessWidget {
  const BotaoPrincipal({
    super.key,
    required this.rotulo,
    required this.aoTocar,
    this.carregando = false,
    this.icone,
  });

  final String rotulo;
  final VoidCallback? aoTocar;
  final bool carregando;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    final corConteudo = Theme.of(context).colorScheme.onPrimary;

    return FilledButton(
      onPressed: carregando ? null : aoTocar,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: carregando
            ? SizedBox(
                key: const ValueKey('carregando'),
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(corConteudo),
                ),
              )
            : Row(
                key: const ValueKey('conteudo'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rotulo),
                  if (icone != null) ...[
                    const SizedBox(width: Dimensoes.espaco8),
                    Icon(icone, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
