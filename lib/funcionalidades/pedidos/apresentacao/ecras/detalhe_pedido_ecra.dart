import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/barra_accoes.dart';
import '../../../../comum/widgets/botao_principal.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../../../../nucleo/tema/tema_app.dart';
import '../../../prestador/dados/dados_falsos.dart';
import '../../dominio/interesse.dart';
import '../../dominio/pedido.dart';
import '../controladores/pedidos_controlador.dart';
import '../widgets/etiqueta_urgencia.dart';

/// Ecrã próprio para o detalhe do pedido — não folha inferior, porque
/// há conteúdo que chega e o utilizador precisa de o ler com calma.
class DetalhePedidoEcra extends ConsumerWidget {
  const DetalhePedidoEcra({super.key, required this.pedidoId});

  final String pedidoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(pedidosControladorProvider);
    final tema = Theme.of(context);
    final superficies = SuperficiesApp.de(context);

    final candidatos = estado.pedidos.where((p) => p.id == pedidoId);
    if (candidatos.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Este pedido já não está disponível.')),
      );
    }
    final pedido = candidatos.first;
    final interesse = estado.interesses[pedidoId];

    return Scaffold(
      appBar: AppBar(title: Text(_nomeServico(pedido.servicoId))),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Dimensoes.margemEcra,
            Dimensoes.espaco16,
            Dimensoes.margemEcra,
            Dimensoes.espaco32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pedido.fotoUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
                  child: Image.network(
                    pedido.fotoUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: Dimensoes.espaco16),
              ],
              Text(_nomeServico(pedido.servicoId), style: tema.textTheme.headlineSmall),
              const SizedBox(height: Dimensoes.espaco8),
              EtiquetaUrgencia(urgencia: pedido.urgencia),
              const SizedBox(height: Dimensoes.espaco16),
              Text(pedido.descricao, style: tema.textTheme.bodyLarge),
              const SizedBox(height: Dimensoes.espaco16),
              Container(
                padding: const EdgeInsets.all(Dimensoes.espaco16),
                decoration: BoxDecoration(
                  border: Border.all(color: tema.colorScheme.outline),
                  borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _linhaInfo(tema, 'Bairro', pedido.bairro),
                    const SizedBox(height: Dimensoes.espaco8),
                    _linhaInfo(tema, 'Pedido feito em', _formatarData(pedido.criadoEm)),
                  ],
                ),
              ),
              const SizedBox(height: Dimensoes.espaco24),
              _blocoContacto(pedido, interesse, tema, superficies),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _barraContacto(context, ref, pedido, interesse),
    );
  }

  Widget _linhaInfo(ThemeData tema, String rotulo, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(rotulo, style: tema.textTheme.bodyMedium),
        Text(valor, style: tema.textTheme.titleSmall),
      ],
    );
  }

  Widget _blocoContacto(
    Pedido pedido,
    Interesse? interesse,
    ThemeData tema,
    SuperficiesApp superficies,
  ) {
    if (interesse == null) return const SizedBox.shrink();

    return switch (interesse.estado) {
      EstadoInteresse.enviado => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            color: superficies.alternativa,
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          ),
          child: Text(
            'O cliente está a comparar os interessados. Avisamos assim que decidir.',
            style: tema.textTheme.bodyMedium,
          ),
        ),
      EstadoInteresse.escolhido => Container(
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            border: Border.all(color: tema.colorScheme.outline),
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pedido.clienteNome, style: tema.textTheme.titleMedium),
              const SizedBox(height: Dimensoes.espaco4),
              Text(pedido.clienteTelefone, style: tema.textTheme.bodyMedium),
              const SizedBox(height: Dimensoes.espaco16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      // TODO: ligar via url_launcher (esquema tel:).
                      onPressed: () {},
                      icon: const Icon(Icons.call_outlined),
                      label: const Text('Ligar'),
                    ),
                  ),
                  const SizedBox(width: Dimensoes.espaco12),
                  Expanded(
                    child: FilledButton.icon(
                      // TODO: abrir WhatsApp via url_launcher (wa.me).
                      onPressed: () {},
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      EstadoInteresse.naoEscolhido => Text(
          'O cliente escolheu outro prestador.',
          style: tema.textTheme.bodyMedium,
        ),
    };
  }

  Widget? _barraContacto(
    BuildContext context,
    WidgetRef ref,
    Pedido pedido,
    Interesse? interesse,
  ) {
    if (interesse == null) {
      return BarraAccoes(
        principal: BotaoPrincipal(
          rotulo: 'Tenho interesse',
          aoTocar: () {
            ref.read(pedidosControladorProvider.notifier).manifestarInteresse(pedido.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Interesse enviado.')),
            );
          },
        ),
      );
    }

    if (interesse.estado == EstadoInteresse.enviado) {
      return BarraAccoes(
        principal: TextButton(
          onPressed: () => _confirmarRetirarInteresse(context, ref, pedido.id),
          child: const Text('Retirar interesse'),
        ),
      );
    }

    return null;
  }

  Future<void> _confirmarRetirarInteresse(
    BuildContext context,
    WidgetRef ref,
    String pedidoId,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirar o interesse?'),
        content: const Text('O cliente deixa de o ver na lista deste pedido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Manter'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Retirar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      ref.read(pedidosControladorProvider.notifier).retirarInteresse(pedidoId);
    }
  }

  String _nomeServico(String servicoId) {
    final candidatos =
        DadosFalsos.categorias.where((categoria) => categoria.id == servicoId);
    return candidatos.isEmpty ? servicoId : candidatos.first.nome;
  }

  String _formatarData(DateTime data) {
    const meses = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return '${data.day} de ${meses[data.month - 1]} de ${data.year}';
  }
}
