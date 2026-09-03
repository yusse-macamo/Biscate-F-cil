import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';
import '../../nucleo/tema/tema_app.dart';

/// Espaço para um documento. Único sítio da tela onde há cartão, porque aqui
/// existe mesmo um objecto físico a representar.
class CartaoDocumento extends StatelessWidget {
  const CartaoDocumento({
    super.key,
    required this.titulo,
    required this.apoio,
    required this.icone,
    required this.aoTocar,
    this.nomeFicheiro,
    this.aoRemover,
  });

  final String titulo;
  final String apoio;
  final IconData icone;
  final VoidCallback aoTocar;

  /// Quando preenchido, o cartão passa ao estado "enviado".
  final String? nomeFicheiro;
  final VoidCallback? aoRemover;

  bool get _enviado => nomeFicheiro != null;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;
    final superficies = SuperficiesApp.de(context);

    return Material(
      color: _enviado ? esquema.surface : superficies.alternativa,
      borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
      child: InkWell(
        onTap: _enviado ? null : aoTocar,
        borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
        child: Container(
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
            border: Border.all(
              color: _enviado ? esquema.primary : esquema.outline,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: _enviado
                      ? esquema.primaryContainer
                      : esquema.surface,
                  borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
                  border: Border.all(color: esquema.outline),
                ),
                child: Icon(
                  _enviado ? Icons.check_rounded : icone,
                  size: 20,
                  color: _enviado ? esquema.primary : superficies.tintaFraca,
                ),
              ),
              const SizedBox(width: Dimensoes.espaco12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: texto.titleMedium),
                    const SizedBox(height: Dimensoes.espaco4),
                    Text(
                      _enviado ? nomeFicheiro! : apoio,
                      style: texto.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_enviado)
                IconButton(
                  onPressed: aoRemover,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Remover',
                  color: superficies.tintaFraca,
                )
              else
                Icon(Icons.add_rounded,
                    size: 20, color: superficies.tintaFraca),
            ],
          ),
        ),
      ),
    );
  }
}
