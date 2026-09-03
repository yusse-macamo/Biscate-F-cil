import 'package:flutter/foundation.dart';

/// Os quatro passos do cadastro do prestador, pela ordem em que são
/// apresentados.
enum PassoCadastro { dados, categoria, documentos, aprovacao }

/// Estado imutável do formulário de cadastro do prestador.
@immutable
class CadastroEstado {
  const CadastroEstado({
    this.passo = PassoCadastro.dados,
    this.nome = '',
    this.telefone = '',
    this.bairro = '',
    this.categoriaId,
    this.zonas = const {},
    this.fotoPerfil,
    this.biFrente,
    this.biVerso,
    this.erros = const {},
    this.aEnviar = false,
  });

  final PassoCadastro passo;

  final String nome;
  final String telefone;
  final String bairro;
  final String? categoriaId;
  final Set<String> zonas;

  /// Nomes de ficheiro dos documentos anexados (simulados, sem backend).
  final String? fotoPerfil;
  final String? biFrente;
  final String? biVerso;

  /// Mensagem de erro por campo.
  final Map<String, String> erros;

  /// Se a submissão está a decorrer.
  final bool aEnviar;

  static const int totalPassos = 4;

  int get indicePasso => passo.index;

  bool get temDocumentosObrigatorios => fotoPerfil != null && biFrente != null;

  CadastroEstado copiarCom({
    PassoCadastro? passo,
    String? nome,
    String? telefone,
    String? bairro,
    String? categoriaId,
    Set<String>? zonas,
    String? fotoPerfil,
    bool limparFotoPerfil = false,
    String? biFrente,
    bool limparBiFrente = false,
    String? biVerso,
    bool limparBiVerso = false,
    Map<String, String>? erros,
    bool? aEnviar,
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
