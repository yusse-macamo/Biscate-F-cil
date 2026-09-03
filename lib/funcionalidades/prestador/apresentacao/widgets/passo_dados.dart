import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/campo_texto.dart';
import '../../../../comum/widgets/fita_passos.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

/// Passo 1: dados pessoais do prestador.
///
/// Os `TextEditingController` vivem aqui (não no estado do Riverpod)
/// para os valores sobreviverem a ir e voltar entre passos.
class PassoDados extends ConsumerStatefulWidget {
  const PassoDados({super.key});

  @override
  ConsumerState<PassoDados> createState() => _PassoDadosState();
}

class _PassoDadosState extends ConsumerState<PassoDados> {
  late final TextEditingController _nomeControlador;
  late final TextEditingController _telefoneControlador;
  late final TextEditingController _bairroControlador;

  @override
  void initState() {
    super.initState();
    final estado = ref.read(cadastroControladorProvider);
    _nomeControlador = TextEditingController(text: estado.nome);
    _telefoneControlador = TextEditingController(text: estado.telefone);
    _bairroControlador = TextEditingController(text: estado.bairro);
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _telefoneControlador.dispose();
    _bairroControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          atual: 0,
          titulo: 'Os seus dados',
          apoio: 'É por aqui que os clientes o contactam depois de o escolherem.',
        ),
        const SizedBox(height: Dimensoes.espaco24),
        CampoTexto(
          etiqueta: 'Nome completo',
          controlador: _nomeControlador,
          dica: 'Como está no BI',
          erro: estado.erros['nome'],
          autofoco: true,
          tipoTeclado: TextInputType.name,
          aoAlterar: controlador.definirNome,
        ),
        const SizedBox(height: Dimensoes.espaco20),
        CampoTexto(
          etiqueta: 'Número de telefone',
          controlador: _telefoneControlador,
          prefixo: '+258 ',
          dica: '84 123 4567',
          auxiliar: 'Use o número que atende durante o dia.',
          erro: estado.erros['telefone'],
          tipoTeclado: TextInputType.number,
          maxLength: 9,
          formatadores: [FilteringTextInputFormatter.digitsOnly],
          aoAlterar: controlador.definirTelefone,
        ),
        const SizedBox(height: Dimensoes.espaco20),
        CampoTexto(
          etiqueta: 'Bairro onde vive',
          controlador: _bairroControlador,
          dica: 'Ex.: Malhangalene',
          erro: estado.erros['bairro'],
          acaoTeclado: TextInputAction.done,
          aoAlterar: controlador.definirBairro,
        ),
      ],
    );
  }
}
