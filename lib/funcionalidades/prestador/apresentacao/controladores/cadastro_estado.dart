import 'package:flutter/foundation.dart';

enum PassoCadastro { dados, categoria, documentos, aprovacao }

/// Estado imutável do formulário de cadastro. Nenhum widget guarda dados de
/// negócio: tudo passa por aqui.
@immutable
class CadastroEstado {
  const CadastroEstado({
    this.passo = PassoCadastro.dados,
    this.nome = '',
    this.telefone = '',
    this.bairro = '',
    this.categoriaId,
    this.zonas = const <String>{},
    this.fotoPerfil,
    this.biFrente,
    this.biVerso,
    this.erros = const <String, String>{},
    this.aEnviar = false,
  });

  final PassoCadastro passo;

  final String nome;
  final String telefone;
  final String bairro;

  final String? categoriaId;
  final Set<String> zonas;

  final String? fotoPerfil;
  final String? biFrente;
  final String? biVerso;

  /// Erros por campo: 'nome', 'telefone', 'bairro', 'categoria', 'zonas',
  /// 'documentos'.
  final Map<String, String> erros;
  final bool aEnviar;

  int get indicePasso => passo.index;
  static int get totalPassos => PassoCadastro.values.length;

  bool get temDocumentosObrigatorios => fotoPerfil != null && biFrente != null;

  CadastroEstado copiarCom({
    PassoCadastro? passo,
    String? nome,
    String? telefone,
    String? bairro,
    String? categoriaId,
    Set<String>? zonas,
    String? fotoPerfil,
    String? biFrente,
    String? biVerso,
    Map<String, String>? erros,
    bool? aEnviar,
    bool limparFotoPerfil = false,
    bool limparBiFrente = false,
    bool limparBiVerso = false,
  }) {
    return CadastroEstado(
      passo: passo ?? this.passo,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      bairro: bairro ?? this.bairro,
      categoriaId: categoriaId ?? this.categoriaId,
      zonas: zonas ?? this.zonas,
      fotoPerfil: limparFotoPerfil ? null : (fotoPerfil ?? this.fotoPerfil),
      biFrente: limparBiFrente ? null : (biFrente ?? this.biFrente),
      biVerso: limparBiVerso ? null : (biVerso ?? this.biVerso),
      erros: erros ?? this.erros,
      aEnviar: aEnviar ?? this.aEnviar,
    );
  }
}
