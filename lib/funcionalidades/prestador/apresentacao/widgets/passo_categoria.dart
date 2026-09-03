import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/fita_passos.dart';
import '../../../../comum/widgets/linha_opcao.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../../dados/dados_falsos.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

/// Passo 2: categoria de serviço e zonas de atuação.
class PassoCategoria extends ConsumerWidget {
  const PassoCategoria({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);
    final tema = Theme.of(context);

    final erroCategoria = estado.erros['categoria'];
    final erroZonas = estado.erros['zonas'];
    final numZonas = estado.zonas.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          atual: 1,
          titulo: 'O que faz e onde',
          apoio: 'Só recebe pedidos do serviço e das zonas que escolher aqui.',
        ),
        const SizedBox(height: Dimensoes.espaco24),
        Text('Serviço que presta', style: tema.textTheme.titleSmall),
        const SizedBox(height: Dimensoes.espaco12),
        for (final categoria in DadosFalsos.categorias) ...[
          LinhaOpcao(
            titulo: categoria.nome,
            descricao: categoria.descricao,
            icone: categoria.icone,
            seleccionada: estado.categoriaId == categoria.id,
            aoTocar: () => controlador.definirCategoria(categoria.id),
          ),
          if (categoria != DadosFalsos.categorias.last)
            const SizedBox(height: Dimensoes.espaco12),
        ],
        if (erroCategoria != null) ...[
          const SizedBox(height: Dimensoes.espaco8),
          _ErroSeccao(texto: erroCategoria),
        ],
        const SizedBox(height: Dimensoes.espaco24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Zonas onde atende', style: tema.textTheme.titleSmall),
            Text(
              numZonas == 0 ? 'Nenhuma' : '$numZonas escolhidas',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: numZonas == 0 ? null : tema.colorScheme.primary,
                fontWeight: numZonas == 0 ? null : FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensoes.espaco12),
        Wrap(
          spacing: Dimensoes.espaco8,
          runSpacing: Dimensoes.espaco8,
          children: [
            for (final zona in DadosFalsos.zonas)
              FilterChip(
                label: Text(zona),
                selected: estado.zonas.contains(zona),
                onSelected: (_) => controlador.alternarZona(zona),
              ),
          ],
        ),
        if (erroZonas != null) ...[
          const SizedBox(height: Dimensoes.espaco8),
          _ErroSeccao(texto: erroZonas),
        ],
      ],
    );
  }
}

class _ErroSeccao extends StatelessWidget {
  const _ErroSeccao({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline_rounded, size: 16, color: tema.colorScheme.error),
        const SizedBox(width: Dimensoes.espaco4),
        Expanded(
          child: Text(
            texto,
            style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
