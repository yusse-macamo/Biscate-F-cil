// Catálogo de categorias e zonas com dados falsos, só para desenvolver
// sem backend. O catálogo definitivo entra depois por migração.

import 'package:flutter/material.dart';

@immutable
class CategoriaFalsa {
  const CategoriaFalsa({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.icone,
  });

  final String id;
  final String nome;
  final String descricao;
  final IconData icone;
}

abstract final class DadosFalsos {
  static const List<CategoriaFalsa> categorias = [
    CategoriaFalsa(
      id: 'canalizacao',
      nome: 'Canalização',
      descricao: 'Torneiras, canos, autoclismos, fugas de água',
      icone: Icons.plumbing_rounded,
    ),
    CategoriaFalsa(
      id: 'electricidade',
      nome: 'Electricidade',
      descricao: 'Instalações, quadros, tomadas, iluminação',
      icone: Icons.electrical_services_rounded,
    ),
    CategoriaFalsa(
      id: 'frio',
      nome: 'Frio e climatização',
      descricao: 'Ar condicionado, arcas, frigoríficos',
      icone: Icons.ac_unit_rounded,
    ),
    CategoriaFalsa(
      id: 'carpintaria',
      nome: 'Carpintaria',
      descricao: 'Portas, armários, móveis, fechaduras',
      icone: Icons.carpenter_rounded,
    ),
  ];

  static const List<String> zonas = [
    'Alto Maé',
    'Polana',
    'Sommerschield',
    'Malhangalene',
    'Maxaquene',
    'Costa do Sol',
    'Laulane',
    'Zimpeto',
    'Matola A',
    'Matola B',
    'Machava',
    'Fomento',
  ];
}
