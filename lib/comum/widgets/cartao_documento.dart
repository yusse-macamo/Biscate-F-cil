import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';
import '../../nucleo/tema/tema_app.dart';

/// Cartão de anexo de documento — o único cartão do ecrã de cadastro,
/// porque aqui há mesmo um objecto a representar.
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
  final String? nomeFicheiro;
  final VoidCallback? aoRemover;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final superficies = SuperficiesApp.de(context);
    final enviado = nomeFicheiro != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enviado ? null : aoTocar,
        borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
        child: Container(
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            color: enviado ? tema.colorScheme.surface : superficies.alternativa,
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
            border: Border.all(
              color: enviado ? tema.colorScheme.primary : tema.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tema.colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
                ),
                child: Icon(
                  enviado ? Icons.check_rounded : icone,
                  color: enviado ? tema.colorScheme.primary : superficies.tintaFraca,
                ),
              ),
              const SizedBox(width: Dimensoes.espaco12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: tema.textTheme.titleSmall),
                    Text(
                      enviado ? nomeFicheiro! : apoio,
                      style: tema.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensoes.espaco12),
              if (enviado)
                IconButton(
                  onPressed: aoRemover,
                  icon: const Icon(Icons.close_rounded),
                )
              else
                Icon(Icons.add_rounded, color: tema.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
