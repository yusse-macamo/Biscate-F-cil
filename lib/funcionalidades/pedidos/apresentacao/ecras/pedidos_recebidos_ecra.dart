import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/botao_principal.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../../../../nucleo/tema/tema_app.dart';
import '../../../prestador/apresentacao/controladores/cadastro_controlador.dart';
import '../../../prestador/dados/dados_falsos.dart';
import '../../dominio/pedido.dart';
import '../controladores/pedidos_controlador.dart';
import '../controladores/pedidos_estado.dart';
import '../widgets/cartao_pedido.dart';
import '../widgets/filtro_pedidos.dart';
import 'detalhe_pedido_ecra.dart';

/// Ecrã de pedidos recebidos: duas abas, Disponíveis e Os meus.
class PedidosRecebidosEcra extends ConsumerStatefulWidget {
  const PedidosRecebidosEcra({super.key});

  @override
  ConsumerState<PedidosRecebidosEcra> createState() => _PedidosRecebidosEcraState();
}

class _PedidosRecebidosEcraState extends ConsumerState<PedidosRecebidosEcra>
    with SingleTickerProviderStateMixin {
  late final TabController _abas;

  @override
  void initState() {
    super.initState();
    final abaInicial = ref.read(pedidosControladorProvider).abaActiva;
    _abas = TabController(
      length: 2,
      vsync: this,
      initialIndex: abaInicial == AbaPedidos.osMeus ? 1 : 0,
    );
    _abas.addListener(() {
      if (_abas.indexIsChanging) return;
      ref.read(pedidosControladorProvider.notifier).mudarAba(
            _abas.index == 0 ? AbaPedidos.disponiveis : AbaPedidos.osMeus,
          );
    });
    ref.read(pedidosControladorProvider.notifier).carregar();
  }

  @override
  void dispose() {
    _abas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(pedidosControladorProvider);
    final controlador = ref.read(pedidosControladorProvider.notifier);
    final perfil = ref.watch(cadastroControladorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controlador.carregar,
          ),
        ],
        bottom: TabBar(
          controller: _abas,
          tabs: const [Tab(text: 'Disponíveis'), Tab(text: 'Os meus')],
        ),
      ),
      body: TabBarView(
        controller: _abas,
        children: [
          _AbaDisponiveis(
            estado: estado,
            pedidos: controlador.disponiveis,
            zonasPerfil: perfil.zonas,
            categoriaId: perfil.categoriaId,
            controlador: controlador,
          ),
          _AbaOsMeus(estado: estado, pedidos: controlador.osMeus, controlador: controlador),
        ],
      ),
    );
  }
}

class _AbaDisponiveis extends StatelessWidget {
  const _AbaDisponiveis({
    required this.estado,
    required this.pedidos,
    required this.zonasPerfil,
    required this.categoriaId,
    required this.controlador,
  });

  final PedidosEstado estado;
  final List<Pedido> pedidos;
  final Set<String> zonasPerfil;
  final String? categoriaId;
  final PedidosControlador controlador;

  @override
  Widget build(BuildContext context) {
    if (estado.aCarregar) return const _ListaEsqueleto();
    if (estado.erro != null) {
      return _EstadoErro(aoTentarNovo: controlador.carregar);
    }

    return Column(
      children: [
        if (zonasPerfil.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimensoes.margemEcra,
              Dimensoes.espaco12,
              Dimensoes.margemEcra,
              0,
            ),
            child: FiltroPedidos(
              zonas: zonasPerfil.toList(),
              filtros: estado.filtros,
              aoAlternarZona: controlador.alternarZonaFiltro,
              aoLimparZonas: controlador.limparFiltroZonas,
              aoAlternarHoje: controlador.alternarFiltroHoje,
            ),
          ),
        Expanded(
          child: pedidos.isEmpty
              ? _EstadoVazio(
                  titulo: 'Ainda não há pedidos nas suas zonas.',
                  apoio: _mensagemApoioVazio(categoriaId, zonasPerfil),
                )
              : _ListaPedidos(pedidos: pedidos),
        ),
      ],
    );
  }
}

class _AbaOsMeus extends StatelessWidget {
  const _AbaOsMeus({required this.estado, required this.pedidos, required this.controlador});

  final PedidosEstado estado;
  final List<Pedido> pedidos;
  final PedidosControlador controlador;

  @override
  Widget build(BuildContext context) {
    if (estado.aCarregar) return const _ListaEsqueleto();
    if (estado.erro != null) {
      return _EstadoErro(aoTentarNovo: controlador.carregar);
    }
    if (pedidos.isEmpty) {
      return const _EstadoVazio(titulo: 'Ainda não mostrou interesse em nenhum pedido.');
    }
    return _ListaPedidos(pedidos: pedidos, estado: estado);
  }
}

class _ListaPedidos extends StatelessWidget {
  const _ListaPedidos({required this.pedidos, this.estado});

  final List<Pedido> pedidos;

  /// Quando presente, mostra a etiqueta do interesse em cada cartão —
  /// usado na aba "Os meus".
  final PedidosEstado? estado;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Dimensoes.margemEcra),
      itemCount: pedidos.length,
      separatorBuilder: (context, indice) => const SizedBox(height: Dimensoes.espaco12),
      itemBuilder: (context, indice) {
        final pedido = pedidos[indice];
        return CartaoPedido(
          pedido: pedido,
          interesse: estado?.interesses[pedido.id],
          aoTocar: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DetalhePedidoEcra(pedidoId: pedido.id)),
          ),
        );
      },
    );
  }
}

class _ListaEsqueleto extends StatelessWidget {
  const _ListaEsqueleto();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Dimensoes.margemEcra),
      itemCount: 3,
      separatorBuilder: (context, indice) => const SizedBox(height: Dimensoes.espaco12),
      itemBuilder: (context, indice) => const _CartaoEsqueleto(),
    );
  }
}

class _CartaoEsqueleto extends StatelessWidget {
  const _CartaoEsqueleto();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final superficies = SuperficiesApp.de(context);

    Widget barra(double largura, double altura) {
      return Container(
        width: largura,
        height: altura,
        decoration: BoxDecoration(
          color: superficies.alternativa,
          borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(Dimensoes.espaco16),
      decoration: BoxDecoration(
        border: Border.all(color: tema.colorScheme.outline),
        borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barra(140, 16),
          const SizedBox(height: Dimensoes.espaco12),
          barra(double.infinity, 12),
          const SizedBox(height: Dimensoes.espaco8),
          barra(200, 12),
          const SizedBox(height: Dimensoes.espaco12),
          barra(100, 10),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio({required this.titulo, this.apoio});

  final String titulo;
  final String? apoio;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensoes.espaco32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titulo, style: tema.textTheme.titleMedium, textAlign: TextAlign.center),
            if (apoio != null) ...[
              const SizedBox(height: Dimensoes.espaco8),
              Text(apoio!, style: tema.textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

class _EstadoErro extends StatelessWidget {
  const _EstadoErro({required this.aoTentarNovo});

  final VoidCallback aoTentarNovo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensoes.espaco32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Não foi possível carregar os pedidos.',
              style: tema.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensoes.espaco16),
            BotaoPrincipal(rotulo: 'Tentar de novo', aoTocar: aoTentarNovo),
          ],
        ),
      ),
    );
  }
}

String? _nomeCategoria(String? categoriaId) {
  if (categoriaId == null) return null;
  final candidatos =
      DadosFalsos.categorias.where((categoria) => categoria.id == categoriaId);
  return candidatos.isEmpty ? null : candidatos.first.nome.toLowerCase();
}

String? _zonasTexto(Set<String> zonas) {
  if (zonas.isEmpty) return null;
  final lista = zonas.toList();
  if (lista.length == 1) return lista.first;
  if (lista.length == 2) return '${lista[0]} ou ${lista[1]}';
  return '${lista.sublist(0, lista.length - 1).join(', ')} ou ${lista.last}';
}

String _mensagemApoioVazio(String? categoriaId, Set<String> zonasPerfil) {
  final categoriaNome = _nomeCategoria(categoriaId);
  final zonasTexto = _zonasTexto(zonasPerfil);
  if (categoriaNome == null || zonasTexto == null) {
    return 'Assim que entrar um pedido nas suas zonas, aparece aqui.';
  }
  return 'Assim que entrar um pedido de $categoriaNome em $zonasTexto, aparece aqui.';
}
