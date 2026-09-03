import 'package:flutter/foundation.dart';

import '../../dominio/interesse.dart';
import '../../dominio/pedido.dart';

/// As duas abas do ecrã de pedidos recebidos.
enum AbaPedidos { disponiveis, osMeus }

/// Filtros escolhidos pelo prestador na aba Disponíveis.
///
/// `zonas` vazio significa "Todas as zonas".
@immutable
class FiltrosPedidos {
  const FiltrosPedidos({this.zonas = const {}, this.apenasHoje = false});

  final Set<String> zonas;
  final bool apenasHoje;

  FiltrosPedidos copiarCom({Set<String>? zonas, bool? apenasHoje}) {
    return FiltrosPedidos(
      zonas: zonas ?? this.zonas,
      apenasHoje: apenasHoje ?? this.apenasHoje,
    );
  }
}

/// Estado imutável do ecrã de pedidos recebidos.
@immutable
class PedidosEstado {
  const PedidosEstado({
    this.pedidos = const [],
    this.interesses = const {},
    this.abaActiva = AbaPedidos.disponiveis,
    this.filtros = const FiltrosPedidos(),
    this.aCarregar = false,
    this.erro,
  });

  final List<Pedido> pedidos;

  /// Interesses deste prestador, por `pedidoId`.
  final Map<String, Interesse> interesses;

  final AbaPedidos abaActiva;
  final FiltrosPedidos filtros;
  final bool aCarregar;
  final String? erro;

  PedidosEstado copiarCom({
    List<Pedido>? pedidos,
    Map<String, Interesse>? interesses,
    AbaPedidos? abaActiva,
    FiltrosPedidos? filtros,
    bool? aCarregar,
    String? erro,
    bool limparErro = false,
  }) {
    return PedidosEstado(
      pedidos: pedidos ?? this.pedidos,
      interesses: interesses ?? this.interesses,
      abaActiva: abaActiva ?? this.abaActiva,
      filtros: filtros ?? this.filtros,
      aCarregar: aCarregar ?? this.aCarregar,
      erro: limparErro ? null : (erro ?? this.erro),
    );
  }
}
