// Pedidos falsos para desenvolver sem backend. O catálogo definitivo
// entra depois, vindo do Supabase.

import '../dominio/interesse.dart';
import '../dominio/pedido.dart';

abstract final class PedidosFalsos {
  /// Oito pedidos de canalização, espalhados por Matola A, Machava,
  /// Zimpeto e Alto Maé. `criadoEm` é calculado a partir de agora, para
  /// os tempos relativos ("há 2 h", "ontem") continuarem a fazer sentido
  /// em qualquer dia em que a app corra.
  static List<Pedido> pedidos() {
    final agora = DateTime.now();

    return [
      Pedido(
        id: 'p1',
        servicoId: 'canalizacao',
        descricao: 'Torneira da cozinha a pingar há dois dias',
        bairro: 'Matola A',
        urgencia: Urgencia.semPressa,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(hours: 2)),
        clienteNome: 'Célia Muianga',
        clienteTelefone: '841234567',
      ),
      Pedido(
        id: 'p2',
        servicoId: 'canalizacao',
        descricao: 'Autoclismo não enche',
        bairro: 'Machava',
        urgencia: Urgencia.estaSemana,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(hours: 5)),
        clienteNome: 'Jorge Sitoe',
        clienteTelefone: '821234567',
      ),
      Pedido(
        id: 'p3',
        servicoId: 'canalizacao',
        descricao: 'Cano rebentado atrás da casa, já fechei a água',
        bairro: 'Zimpeto',
        urgencia: Urgencia.hoje,
        // Já tem um interesse escolhido — ver `interesses()`.
        estado: EstadoPedido.aceite,
        criadoEm: agora.subtract(const Duration(hours: 1)),
        clienteNome: 'Amélia Cossa',
        clienteTelefone: '871234567',
      ),
      Pedido(
        id: 'p4',
        servicoId: 'canalizacao',
        descricao: 'Fuga de água por baixo do lavatório da casa de banho',
        bairro: 'Alto Maé',
        urgencia: Urgencia.hoje,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(hours: 3)),
        clienteNome: 'Nelson Tembe',
        clienteTelefone: '831234567',
      ),
      Pedido(
        id: 'p5',
        servicoId: 'canalizacao',
        descricao: 'Chuveiro sem pressão desde ontem',
        bairro: 'Matola A',
        urgencia: Urgencia.semPressa,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(days: 1)),
        clienteNome: 'Ivone Macuácua',
        clienteTelefone: '861234567',
      ),
      Pedido(
        id: 'p6',
        servicoId: 'canalizacao',
        descricao: 'Sifão da cozinha entupido, água não escoa',
        bairro: 'Machava',
        urgencia: Urgencia.estaSemana,
        // Já tem um interesse enviado — ver `interesses()`.
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(hours: 6)),
        clienteNome: 'Óscar Nhantumbo',
        clienteTelefone: '851234567',
      ),
      Pedido(
        id: 'p7',
        servicoId: 'canalizacao',
        descricao: 'Torneira do quintal partiu, está a jorrar água',
        bairro: 'Zimpeto',
        urgencia: Urgencia.hoje,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(minutes: 30)),
        clienteNome: 'Graça Wamba',
        clienteTelefone: '821234568',
      ),
      Pedido(
        id: 'p8',
        servicoId: 'canalizacao',
        descricao: 'Autoclismo a correr água o dia todo',
        bairro: 'Alto Maé',
        urgencia: Urgencia.estaSemana,
        estado: EstadoPedido.aberto,
        criadoEm: agora.subtract(const Duration(days: 2)),
        clienteNome: 'Domingos Chissano',
        clienteTelefone: '871234568',
      ),
    ];
  }

  /// Dois pedidos já com interesse — um `enviado` e um `escolhido` — para
  /// se poder ver o bloco do contacto sem ter de clicar em nada.
  static List<Interesse> interesses() {
    final agora = DateTime.now();

    return [
      Interesse(
        pedidoId: 'p6',
        estado: EstadoInteresse.enviado,
        enviadoEm: agora.subtract(const Duration(hours: 3)),
      ),
      Interesse(
        pedidoId: 'p3',
        estado: EstadoInteresse.escolhido,
        enviadoEm: agora.subtract(const Duration(hours: 4)),
      ),
    ];
  }
}
