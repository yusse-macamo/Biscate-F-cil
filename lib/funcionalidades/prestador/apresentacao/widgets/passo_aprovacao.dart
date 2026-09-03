import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../nucleo/tema/dimensoes.dart';
import '../../dados/dados_falsos.dart';
import '../controladores/cadastro_controlador.dart';

class PassoAprovacao extends ConsumerWidget {
  const PassoAprovacao({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final esquema = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    String? categoria;
    for (final c in categoriasFalsas) {
      if (c.id == estado.categoriaId) categoria = c.nome;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensoes.espaco24),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: esquema.primaryContainer,
            borderRadius: BorderRadius.circular(Dimensoes.raioGrande),
          ),
          child: Icon(Icons.check_rounded, color: esquema.primary, size: 28),
        ),
        const SizedBox(height: Dimensoes.espaco24),
        Text('Cadastro enviado', style: texto.headlineMedium),
        const SizedBox(height: Dimensoes.espaco8),
        Text(
          'Verificamos os seus documentos e ligamos-lhe para o '
          '+258 ${estado.telefone} até dois dias úteis. Depois disso já pode '
          'definir os seus preços.',
          style: texto.bodyMedium,
        ),
        const SizedBox(height: Dimensoes.espaco32),
        Container(
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
            border: Border.all(color: esquema.outline),
          ),
          child: Column(
            children: [
              _Linha(rotulo: 'Nome', valor: estado.nome),
              const Divider(height: Dimensoes.espaco24),
              _Linha(rotulo: 'Serviço', valor: categoria ?? '—'),
              const Divider(height: Dimensoes.espaco24),
              _Linha(
                rotulo: 'Zonas',
                valor: estado.zonas.isEmpty
                    ? '—'
                    : estado.zonas.take(3).join(', ') +
                        (estado.zonas.length > 3
                            ? ' +${estado.zonas.length - 3}'
                            : ''),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Linha extends StatelessWidget {
  const _Linha({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 92, child: Text(rotulo, style: texto.bodyMedium)),
        Expanded(
          child: Text(
            valor,
            style: texto.titleSmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
