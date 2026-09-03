import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cadastro_estado.dart';

final cadastroControladorProvider =
    NotifierProvider<CadastroControlador, CadastroEstado>(CadastroControlador.new);

/// Controlador do cadastro do prestador. Guarda os dados dos quatro
/// passos e faz toda a validação; os widgets só lêem o estado e chamam
/// estes métodos.
class CadastroControlador extends Notifier<CadastroEstado> {
  @override
  CadastroEstado build() => const CadastroEstado();

  static final RegExp _regexTelefone = RegExp(r'^8[2-7]\d{7}$');

  // --- Campos ---

  void definirNome(String valor) {
    state = state.copiarCom(nome: valor, erros: _semErro('nome'));
  }

  void definirTelefone(String valor) {
    state = state.copiarCom(telefone: valor, erros: _semErro('telefone'));
  }

  void definirBairro(String valor) {
    state = state.copiarCom(bairro: valor, erros: _semErro('bairro'));
  }

  void definirCategoria(String categoriaId) {
    state = state.copiarCom(
      categoriaId: categoriaId,
      erros: _semErro('categoria'),
    );
  }

  void alternarZona(String zona) {
    final zonas = Set<String>.from(state.zonas);
    if (!zonas.remove(zona)) zonas.add(zona);
    state = state.copiarCom(zonas: zonas, erros: _semErro('zonas'));
  }

  void definirFotoPerfil(String nomeFicheiro) {
    state = state.copiarCom(
      fotoPerfil: nomeFicheiro,
      erros: _semErro('documentos'),
    );
  }

  void definirBiFrente(String nomeFicheiro) {
    state = state.copiarCom(
      biFrente: nomeFicheiro,
      erros: _semErro('documentos'),
    );
  }

  void definirBiVerso(String nomeFicheiro) {
    state = state.copiarCom(
      biVerso: nomeFicheiro,
      erros: _semErro('documentos'),
    );
  }

  // --- Navegação ---

  Future<bool> avancar() async {
    final erros = _validarPasso(state.passo);
    if (erros.isNotEmpty) {
      state = state.copiarCom(erros: {...state.erros, ...erros});
      return false;
    }

    if (state.passo == PassoCadastro.documentos) {
      await _submeter();
      return true;
    }

    state = state.copiarCom(
      passo: PassoCadastro.values[state.passo.index + 1],
      erros: const {},
    );
    return true;
  }

  bool recuar() {
    if (state.passo == PassoCadastro.dados ||
        state.passo == PassoCadastro.aprovacao) {
      return false;
    }
    state = state.copiarCom(
      passo: PassoCadastro.values[state.passo.index - 1],
      erros: const {},
    );
    return true;
  }

  Future<void> _submeter() async {
    state = state.copiarCom(aEnviar: true);
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO: aqui entra o repositório (Supabase + upload dos documentos já
    // comprimidos). A interface não muda.
    state = state.copiarCom(aEnviar: false, passo: PassoCadastro.aprovacao);
  }

  // --- Validação ---

  Map<String, String> _validarPasso(PassoCadastro passo) {
    return switch (passo) {
      PassoCadastro.dados => _validarDados(),
      PassoCadastro.categoria => _validarCategoria(),
      PassoCadastro.documentos => _validarDocumentos(),
      PassoCadastro.aprovacao => const {},
    };
  }

  Map<String, String> _validarDados() {
    final erros = <String, String>{};

    final nome = state.nome.trim();
    if (nome.length < 5 || !nome.contains(' ')) {
      erros['nome'] = 'Escreva o nome completo, como está no BI.';
    }

    final telefone = state.telefone.replaceAll(' ', '');
    if (!_regexTelefone.hasMatch(telefone)) {
      erros['telefone'] = 'Número de 9 dígitos, começado por 82 a 87.';
    }

    if (state.bairro.trim().length < 3) {
      erros['bairro'] = 'Indique o bairro onde vive.';
    }

    return erros;
  }

  Map<String, String> _validarCategoria() {
    final erros = <String, String>{};

    if (state.categoriaId == null) {
      erros['categoria'] = 'Escolha o serviço que presta.';
    }
    if (state.zonas.isEmpty) {
      erros['zonas'] = 'Escolha pelo menos uma zona onde atende.';
    }

    return erros;
  }

  Map<String, String> _validarDocumentos() {
    if (state.temDocumentosObrigatorios) return const {};
    return {'documentos': 'Faltam a foto de perfil e a frente do BI.'};
  }

  Map<String, String> _semErro(String campo) {
    if (!state.erros.containsKey(campo)) return state.erros;
    return Map<String, String>.from(state.erros)..remove(campo);
  }
}
