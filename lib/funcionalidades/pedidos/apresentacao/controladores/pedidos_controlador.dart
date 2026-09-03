import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../prestador/apresentacao/controladores/cadastro_controlador.dart';
import '../../dados/pedidos_falsos.dart';
import '../../dominio/interesse.dart';
import '../../dominio/pedido.dart';
import 'pedidos_estado.dart';

final pedidosControladorProvider =
    NotifierProvider<PedidosControlador, PedidosEstado>(PedidosControlador.new);

/// Controlador do ecrã de pedidos recebidos. Os widgets só lêem
/// `disponiveis`/`osMeus` e chamam estes métodos — nenhuma filtragem
/// nem ordenação vive nos widgets.
class PedidosControlador extends Notifier<PedidosEstado> {
  @override
  PedidosEstado build() => const PedidosEstado();

  Future<void> carregar() async {
    state = state.copiarCom(aCarregar: true, limparErro: true);
    await Future.delayed(const Duration(milliseconds: 800));

    final interesses = <String, Interesse>{
      for (final interesse in PedidosFalsos.interesses())
        interesse.pedidoId: interesse,
    };

    state = state.copiarCom(
      pedidos: PedidosFalsos.pedidos(),
      interesses: interesses,
      aCarregar: false,
    );
  }

  void manifestarInteresse(String pedidoId) {
    // TODO: chamar o repositório (Supabase) para registar o interesse.
    final interesses = Map<String, Interesse>.from(state.interesses);
    interesses[pedidoId] = Interesse(
      pedidoId: pedidoId,
      estado: EstadoInteresse.enviado,
      enviadoEm: DateTime.now(),
    );
    state = state.copiarCom(interesses: interesses);
  }

  void retirarInteresse(String pedidoId) {
    // TODO: chamar o repositório (Supabase) para retirar o interesse.
    final interesses = Map<String, Interesse>.from(state.interesses)
      ..remove(pedidoId);
    state = state.copiarCom(interesses: interesses);
  }

  void mudarAba(AbaPedidos aba) {
    state = state.copiarCom(abaActiva: aba);
  }

  void alternarZonaFiltro(String zona) {
    final zonas = Set<String>.from(state.filtros.zonas);
    if (!zonas.remove(zona)) zonas.add(zona);
    state = state.copiarCom(filtros: state.filtros.copiarCom(zonas: zonas));
  }

  void limparFiltroZonas() {
    state = state.copiarCom(filtros: state.filtros.copiarCom(zonas: const {}));
  }

  void alternarFiltroHoje() {
    state = state.copiarCom(
      filtros: state.filtros.copiarCom(apenasHoje: !state.filtros.apenasHoje),
    );
  }

  /// Pedidos `aberto` da categoria e zonas do prestador, ainda sem
  /// interesse manifestado, com os filtros da aba aplicados. Mais
  /// recentes primeiro.
  List<Pedido> get disponiveis {
    final perfil = ref.read(cadastroControladorProvider);
    final zonasPerfil = perfil.zonas;

    final lista = state.pedidos.where((pedido) {
      if (pedido.estado != EstadoPedido.aberto) return false;
      if (state.interesses.containsKey(pedido.id)) return false;
      if (perfil.categoriaId != null && pedido.servicoId != perfil.categoriaId) {
        return false;
      }
      if (zonasPerfil.isNotEmpty && !zonasPerfil.contains(pedido.bairro)) {
        return false;
      }
      if (state.filtros.zonas.isNotEmpty &&
          !state.filtros.zonas.contains(pedido.bairro)) {
        return false;
      }
      if (state.filtros.apenasHoje && pedido.urgencia != Urgencia.hoje) {
        return false;
      }
      return true;
    }).toList();

    lista.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return lista;
  }

  /// Pedidos onde já manifestou interesse, `escolhido` primeiro, depois
  /// `enviado`, depois `nao_escolhido`.
  List<Pedido> get osMeus {
    final lista = state.pedidos
        .where((pedido) => state.interesses.containsKey(pedido.id))
        .toList();

    lista.sort((a, b) {
      final estadoA = state.interesses[a.id]!.estado;
      final estadoB = state.interesses[b.id]!.estado;
      return _prioridadeInteresse(estadoA).compareTo(_prioridadeInteresse(estadoB));
    });

    return lista;
  }

  int _prioridadeInteresse(EstadoInteresse estado) {
    return switch (estado) {
      EstadoInteresse.escolhido => 0,
      EstadoInteresse.enviado => 1,
      EstadoInteresse.naoEscolhido => 2,
    };
  }
}
