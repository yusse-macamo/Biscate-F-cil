import 'package:flutter/material.dart';

import '../../../../comum/widgets/etiqueta_estado.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../../../prestador/dados/dados_falsos.dart';
import '../../dominio/interesse.dart';
import '../../dominio/pedido.dart';
import 'etiqueta_urgencia.dart';

/// Cartão de um pedido, na lista de Disponíveis ou de Os meus. Contorno
/// de 1px e raio médio, sem sombra, tal como o resto da app.
class CartaoPedido extends StatelessWidget {
  const CartaoPedido({
    super.key,
    required this.pedido,
    required this.aoTocar,
    this.interesse,
  });

  final Pedido pedido;
  final VoidCallback aoTocar;

  /// Quando não nulo, mostra a [EtiquetaEstado] do interesse no rodapé —
  /// usado na aba "Os meus".
  final Interesse? interesse;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
        child: Container(
          padding: const EdgeInsets.all(Dimensoes.espaco16),
          decoration: BoxDecoration(
            border: Border.all(color: tema.colorScheme.outline),
            borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pedido.fotoUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
                  child: Image.network(
                    pedido.fotoUrl!,
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Dimensoes.espaco12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _nomeServico(pedido.servicoId),
                            style: tema.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: Dimensoes.espaco8),
                        EtiquetaUrgencia(urgencia: pedido.urgencia),
                      ],
                    ),
                    const SizedBox(height: Dimensoes.espaco8),
                    Text(
                      pedido.descricao,
                      style: tema.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensoes.espaco8),
                    Text(
                      '${pedido.bairro} · ${_tempoRelativo(pedido.criadoEm)}',
                      style: tema.textTheme.bodySmall,
                    ),
                    if (interesse != null) ...[
                      const SizedBox(height: Dimensoes.espaco8),
                      EtiquetaEstado(
                        texto: _rotuloInteresse(interesse!.estado),
                        tom: _tomInteresse(interesse!.estado),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _nomeServico(String servicoId) {
    final candidatos =
        DadosFalsos.categorias.where((categoria) => categoria.id == servicoId);
    return candidatos.isEmpty ? servicoId : candidatos.first.nome;
  }

  String _rotuloInteresse(EstadoInteresse estado) {
    return switch (estado) {
      EstadoInteresse.enviado => 'Enviado',
      EstadoInteresse.escolhido => 'Escolhido',
      EstadoInteresse.naoEscolhido => 'Não escolhido',
    };
  }

  TomEtiqueta _tomInteresse(EstadoInteresse estado) {
    return switch (estado) {
      EstadoInteresse.escolhido => TomEtiqueta.positivo,
      EstadoInteresse.enviado => TomEtiqueta.neutro,
      EstadoInteresse.naoEscolhido => TomEtiqueta.negativo,
    };
  }

  String _tempoRelativo(DateTime desde) {
    final diferenca = DateTime.now().difference(desde);
    if (diferenca.inMinutes < 1) return 'agora';
    if (diferenca.inMinutes < 60) return 'há ${diferenca.inMinutes} min';
    if (diferenca.inHours < 24) return 'há ${diferenca.inHours} h';
    if (diferenca.inHours < 48) return 'ontem';
    return 'há ${diferenca.inDays} dias';
  }
}
