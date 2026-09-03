import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/cartao_documento.dart';
import '../../../../comum/widgets/fita_passos.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

class PassoDocumentos extends ConsumerWidget {
  const PassoDocumentos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);
    final esquema = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    // TODO(dados): trocar por image_picker + compressão antes do upload.
    // A câmara devolve ficheiros de vários MB e a rede aqui não perdoa.
    void escolher(void Function(String) definir, String nome) => definir(nome);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          actual: PassoCadastro.documentos.index,
          titulo: 'Documentos',
          apoio:
              'Confirmamos a sua identidade antes de o mostrar aos clientes. '
              'Só a foto de perfil fica visível.',
        ),
        const SizedBox(height: Dimensoes.espaco32),
        CartaoDocumento(
          titulo: 'Foto de perfil',
          apoio: 'Rosto visível, sem óculos escuros',
          icone: Icons.person_outline_rounded,
          nomeFicheiro: estado.fotoPerfil,
          aoTocar: () => escolher(controlador.definirFotoPerfil, 'perfil.jpg'),
          aoRemover: () => controlador.definirFotoPerfil(null),
        ),
        const SizedBox(height: Dimensoes.espaco12),
        CartaoDocumento(
          titulo: 'BI, frente',
          apoio: 'Toda a página dentro da foto',
          icone: Icons.badge_outlined,
          nomeFicheiro: estado.biFrente,
          aoTocar: () => escolher(controlador.definirBiFrente, 'bi-frente.jpg'),
          aoRemover: () => controlador.definirBiFrente(null),
        ),
        const SizedBox(height: Dimensoes.espaco12),
        CartaoDocumento(
          titulo: 'BI, verso (opcional)',
          apoio: 'Acelera a aprovação',
          icone: Icons.badge_outlined,
          nomeFicheiro: estado.biVerso,
          aoTocar: () => escolher(controlador.definirBiVerso, 'bi-verso.jpg'),
          aoRemover: () => controlador.definirBiVerso(null),
        ),
        if (estado.erros['documentos'] != null) ...[
          const SizedBox(height: Dimensoes.espaco12),
          Row(
            children: [
              Icon(Icons.error_outline_rounded, size: 16, color: esquema.error),
              const SizedBox(width: Dimensoes.espaco8),
              Expanded(
                child: Text(
                  estado.erros['documentos']!,
                  style: texto.bodySmall?.copyWith(
                    color: esquema.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: Dimensoes.espaco24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline_rounded,
                size: 16, color: esquema.onSurfaceVariant),
            const SizedBox(width: Dimensoes.espaco8),
            Expanded(
              child: Text(
                'Os documentos são vistos apenas pela equipa que aprova os '
                'cadastros.',
                style: texto.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
