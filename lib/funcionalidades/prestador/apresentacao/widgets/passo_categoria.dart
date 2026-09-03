import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/fita_passos.dart';
import '../../../../comum/widgets/linha_opcao.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../../dados/dados_falsos.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

class PassoCategoria extends ConsumerWidget {
  const PassoCategoria({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);
    final texto = Theme.of(context).textTheme;
    final esquema = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          actual: PassoCadastro.categoria.index,
          titulo: 'O que faz e onde',
          apoio: 'Só recebe pedidos do serviço e das zonas que escolher aqui.',
        ),
        const SizedBox(height: Dimensoes.espaco32),

        Text('Serviço que presta', style: texto.titleSmall),
        const SizedBox(height: Dimensoes.espaco12),
        ...categoriasFalsas.map(
          (categoria) => Padding(
            padding: const EdgeInsets.only(bottom: Dimensoes.espaco12),
            child: LinhaOpcao(
              titulo: categoria.nome,
              descricao: categoria.descricao,
              icone: categoria.icone,
              seleccionada: estado.categoriaId == categoria.id,
              aoTocar: () => controlador.definirCategoria(categoria.id),
            ),
          ),
        ),
        if (estado.erros['categoria'] != null)
          _Erro(mensagem: estado.erros['categoria']!),

        const SizedBox(height: Dimensoes.espaco24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Zonas onde atende', style: texto.titleSmall),
            Text(
              estado.zonas.isEmpty
                  ? 'Nenhuma'
                  : '${estado.zonas.length} escolhidas',
              style: texto.bodySmall?.copyWith(
                color: estado.zonas.isEmpty ? null : esquema.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensoes.espaco12),
        Wrap(
          spacing: Dimensoes.espaco8,
          runSpacing: Dimensoes.espaco8,
          children: zonasFalsas
              .map(
                (zona) => FilterChip(
                  label: Text(zona),
                  selected: estado.zonas.contains(zona),
                  onSelected: (_) => controlador.alternarZona(zona),
                ),
              )
              .toList(),
        ),
        if (estado.erros['zonas'] != null)
          _Erro(mensagem: estado.erros['zonas']!),
      ],
    );
  }
}

class _Erro extends StatelessWidget {
  const _Erro({required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: Dimensoes.espaco8),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: esquema.error),
          const SizedBox(width: Dimensoes.espaco8),
          Expanded(
            child: Text(
              mensagem,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: esquema.error, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
