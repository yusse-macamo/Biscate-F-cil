import 'package:flutter/material.dart';

import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/pedidos_estado.dart';

/// Linha de filtros da aba Disponíveis: zonas do prestador (selecção
/// múltipla, "Todas as zonas" limpa as outras) e urgência "Hoje".
class FiltroPedidos extends StatelessWidget {
  const FiltroPedidos({
    super.key,
    required this.zonas,
    required this.filtros,
    required this.aoAlternarZona,
    required this.aoLimparZonas,
    required this.aoAlternarHoje,
  });

  final List<String> zonas;
  final FiltrosPedidos filtros;
  final ValueChanged<String> aoAlternarZona;
  final VoidCallback aoLimparZonas;
  final VoidCallback aoAlternarHoje;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Dimensoes.espaco8),
            child: FilterChip(
              label: const Text('Todas as zonas'),
              selected: filtros.zonas.isEmpty,
              onSelected: (_) => aoLimparZonas(),
            ),
          ),
          for (final zona in zonas)
            Padding(
              padding: const EdgeInsets.only(right: Dimensoes.espaco8),
              child: FilterChip(
                label: Text(zona),
                selected: filtros.zonas.contains(zona),
                onSelected: (_) => aoAlternarZona(zona),
              ),
            ),
          FilterChip(
            label: const Text('Hoje'),
            selected: filtros.apenasHoje,
            onSelected: (_) => aoAlternarHoje(),
          ),
        ],
      ),
    );
  }
}
