import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/cartao_documento.dart';
import '../../../../comum/widgets/fita_passos.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

/// Passo 3: documentos exigidos para aprovação.
class PassoDocumentos extends ConsumerWidget {
  const PassoDocumentos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);
    final tema = Theme.of(context);

    final erroDocumentos = estado.erros['documentos'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          atual: 2,
          titulo: 'Documentos',
          apoio:
              'Confirmamos a sua identidade antes de o mostrar aos clientes. '
              'Só a foto de perfil fica visível.',
        ),
        const SizedBox(height: Dimensoes.espaco24),
        CartaoDocumento(
          titulo: 'Foto de perfil',
          apoio: 'Rosto visível, sem óculos escuros',
          icone: Icons.person_outline_rounded,
          nomeFicheiro: estado.fotoPerfil,
          // TODO: trocar por image_picker com compressão antes do upload —
          // a câmara devolve ficheiros de vários MB e a rede aqui não perdoa.
          aoTocar: () => controlador.definirFotoPerfil('perfil.jpg'),
        ),
        const SizedBox(height: Dimensoes.espaco12),
        CartaoDocumento(
          titulo: 'BI, frente',
          apoio: 'Toda a página dentro da foto',
          icone: Icons.badge_outlined,
          nomeFicheiro: estado.biFrente,
          aoTocar: () => controlador.definirBiFrente('bi_frente.jpg'),
        ),
        const SizedBox(height: Dimensoes.espaco12),
        CartaoDocumento(
          titulo: 'BI, verso (opcional)',
          apoio: 'Acelera a aprovação',
          icone: Icons.badge_outlined,
          nomeFicheiro: estado.biVerso,
          aoTocar: () => controlador.definirBiVerso('bi_verso.jpg'),
        ),
        if (erroDocumentos != null) ...[
          const SizedBox(height: Dimensoes.espaco12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, size: 16, color: tema.colorScheme.error),
              const SizedBox(width: Dimensoes.espaco4),
              Expanded(
                child: Text(
                  erroDocumentos,
                  style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.error),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: Dimensoes.espaco12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: tema.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: Dimensoes.espaco4),
            Expanded(
              child: Text(
                'Os documentos são vistos apenas pela equipa que aprova os cadastros.',
                style: tema.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
