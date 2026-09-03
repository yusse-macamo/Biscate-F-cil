import 'package:flutter/foundation.dart';

/// Estado do interesse deste prestador num pedido. Só existe do lado do
/// prestador — não confundir com `EstadoPedido`.
enum EstadoInteresse { enviado, escolhido, naoEscolhido }

@immutable
class Interesse {
  const Interesse({
    required this.pedidoId,
    required this.estado,
    required this.enviadoEm,
  });

  final String pedidoId;
  final EstadoInteresse estado;
  final DateTime enviadoEm;
}
