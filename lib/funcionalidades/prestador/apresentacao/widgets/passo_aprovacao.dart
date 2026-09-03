import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../nucleo/tema/dimensoes.dart';
import '../../dados/dados_falsos.dart';
import '../controladores/cadastro_controlador.dart';

/// Passo 4: confirmação de que o cadastro foi enviado para aprovação.
///
/// Sem cabeçalho de passo nem fita — já não há mais nada a preencher.
class PassoAprovacao extends ConsumerWidget {
  const PassoAprovacao({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final tema = Theme.of(context);

    final candidatos =
        DadosFalsos.categorias.where((c) => c.id == estado.categoriaId);
    final categoria = candidatos.isEmpty ? null : candidatos.first;

    final zonas = estado.zonas.toList();
    final zonasTexto = zonas.length <= 3
        ? zonas.join(', ')
        : '${zonas.take(3).join(', ')} +${zonas.length - 3}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tema.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(Dimensoes.raioGrande),
          ),
          child: Icon(Icons.check_rounded, color: tema.colorScheme.primary),
        ),
        const SizedBox(height: Dimensoes.espaco20),
        Text('Cadastro enviado', style: tema.textTheme.headlineMedium),
        const SizedBox(height: Dimensoes.espaco8),
        Text(
          'Verificamos os seus documentos e ligamos-lhe para o '
          '+258 ${estado.telefone} até dois dias úteis. Depois disso já '
          'pode definir os seus preços.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: Dimensoes.espaco24),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: tema.colorScheme.outline),
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          ),
          child: Column(
            children: [
              _LinhaResumo(rotulo: 'Nome', valor: estado.nome),
              Divider(height: 1, color: tema.colorScheme.outline),
              _LinhaResumo(rotulo: 'Serviço', valor: categoria?.nome ?? ''),
              Divider(height: 1, color: tema.colorScheme.outline),
              _LinhaResumo(rotulo: 'Zonas', valor: zonasTexto),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinhaResumo extends StatelessWidget {
  const _LinhaResumo({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensoes.espaco16,
        vertical: Dimensoes.espaco12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rotulo, style: tema.textTheme.bodyMedium),
          Text(valor, style: tema.textTheme.titleSmall),
        ],
      ),
    );
  }
}
