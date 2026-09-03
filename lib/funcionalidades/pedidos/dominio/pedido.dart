import 'package:flutter/foundation.dart';

/// Estado do pedido, partilhado com a pista do cliente — não alterar
/// sem combinar.
enum EstadoPedido { aberto, aceite, concluido, cancelado }

/// Urgência do pedido, escolhida pelo cliente.
enum Urgencia {
  hoje('Hoje'),
  estaSemana('Esta semana'),
  semPressa('Sem pressa');

  const Urgencia(this.rotulo);

  final String rotulo;
}

@immutable
class Pedido {
  const Pedido({
    required this.id,
    required this.servicoId,
    required this.descricao,
    this.fotoUrl,
    required this.bairro,
    required this.urgencia,
    required this.estado,
    required this.criadoEm,
    required this.clienteNome,
    required this.clienteTelefone,
  });

  final String id;
  final String servicoId;
  final String descricao;
  final String? fotoUrl;
  final String bairro;
  final Urgencia urgencia;
  final EstadoPedido estado;
  final DateTime criadoEm;
  final String clienteNome;

  /// Nunca mostrar enquanto o interesse deste prestador não estiver
  /// `escolhido`. Nesta fase é uma regra de interface; quando o Supabase
  /// entrar, passa a política RLS e o campo deixa de sequer vir na consulta.
  final String clienteTelefone;
}
