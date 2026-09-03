import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cadastro_estado.dart';

final cadastroControladorProvider =
    NotifierProvider<CadastroControlador, CadastroEstado>(
  CadastroControlador.new,
);

/// Toda a lógica do cadastro: validação, avanço de passo e submissão.
/// Os ecrãs limitam-se a ler o estado e a chamar estes métodos.
class CadastroControlador extends Notifier<CadastroEstado> {
  /// Números moçambicanos: 9 dígitos começados por 82-87.
  static final RegExp _telefoneValido = RegExp(r'^8[2-7]\d{7}$');

  @override
  CadastroEstado build() => const CadastroEstado();

  // ---- Alterações de campo -------------------------------------------------

  void definirNome(String valor) =>
      state = state.copiarCom(nome: valor, erros: _semErro('nome'));

  void definirTelefone(String valor) =>
      state = state.copiarCom(telefone: valor, erros: _semErro('telefone'));

  void definirBairro(String valor) =>
      state = state.copiarCom(bairro: valor, erros: _semErro('bairro'));

  void definirCategoria(String id) =>
      state = state.copiarCom(categoriaId: id, erros: _semErro('categoria'));

  void alternarZona(String zona) {
    final zonas = Set<String>.from(state.zonas);
    zonas.contains(zona) ? zonas.remove(zona) : zonas.add(zona);
    state = state.copiarCom(zonas: zonas, erros: _semErro('zonas'));
  }

  void definirFotoPerfil(String? nome) => state = nome == null
      ? state.copiarCom(limparFotoPerfil: true)
      : state.copiarCom(fotoPerfil: nome, erros: _semErro('documentos'));

  void definirBiFrente(String? nome) => state = nome == null
      ? state.copiarCom(limparBiFrente: true)
      : state.copiarCom(biFrente: nome, erros: _semErro('documentos'));

  void definirBiVerso(String? nome) => state = nome == null
      ? state.copiarCom(limparBiVerso: true)
      : state.copiarCom(biVerso: nome);

  // ---- Navegação -----------------------------------------------------------

  /// Devolve `true` se avançou. Quando falha, os erros ficam no estado.
  Future<bool> avancar() async {
    final erros = _validarPassoActual();
    if (erros.isNotEmpty) {
      state = state.copiarCom(erros: erros);
      return false;
    }

    switch (state.passo) {
      case PassoCadastro.dados:
        state = state.copiarCom(passo: PassoCadastro.categoria);
      case PassoCadastro.categoria:
        state = state.copiarCom(passo: PassoCadastro.documentos);
      case PassoCadastro.documentos:
        await _submeter();
      case PassoCadastro.aprovacao:
        break;
    }
    return true;
  }

  /// Devolve `false` quando já está no primeiro passo (para o ecrã decidir se
  /// fecha ou não).
  bool recuar() {
    switch (state.passo) {
      case PassoCadastro.dados:
      case PassoCadastro.aprovacao:
        return false;
      case PassoCadastro.categoria:
        state = state.copiarCom(passo: PassoCadastro.dados, erros: const {});
        return true;
      case PassoCadastro.documentos:
        state =
            state.copiarCom(passo: PassoCadastro.categoria, erros: const {});
        return true;
    }
  }

  Future<void> _submeter() async {
    state = state.copiarCom(aEnviar: true);
    // TODO(dados): substituir pela chamada ao repositório (Supabase + upload
    // dos documentos já comprimidos). A interface não muda.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    state = state.copiarCom(aEnviar: false, passo: PassoCadastro.aprovacao);
  }

  // ---- Validação -----------------------------------------------------------

  Map<String, String> _validarPassoActual() {
    final erros = <String, String>{};
    switch (state.passo) {
      case PassoCadastro.dados:
        if (state.nome.trim().length < 5 || !state.nome.trim().contains(' ')) {
          erros['nome'] = 'Escreva o nome completo, como está no BI.';
        }
        final telefone = state.telefone.replaceAll(' ', '');
        if (!_telefoneValido.hasMatch(telefone)) {
          erros['telefone'] = 'Número de 9 dígitos, começado por 82 a 87.';
        }
        if (state.bairro.trim().length < 3) {
          erros['bairro'] = 'Indique o bairro onde vive.';
        }
      case PassoCadastro.categoria:
        if (state.categoriaId == null) {
          erros['categoria'] = 'Escolha o serviço que presta.';
        }
        if (state.zonas.isEmpty) {
          erros['zonas'] = 'Escolha pelo menos uma zona onde atende.';
        }
      case PassoCadastro.documentos:
        if (!state.temDocumentosObrigatorios) {
          erros['documentos'] =
              'Faltam a foto de perfil e a frente do BI.';
        }
      case PassoCadastro.aprovacao:
        break;
    }
    return erros;
  }

  Map<String, String> _semErro(String campo) {
    if (!state.erros.containsKey(campo)) return state.erros;
    return Map<String, String>.from(state.erros)..remove(campo);
  }
}
