import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/campo_texto.dart';
import '../../../../comum/widgets/fita_passos.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';

class PassoDados extends ConsumerStatefulWidget {
  const PassoDados({super.key});

  @override
  ConsumerState<PassoDados> createState() => _PassoDadosState();
}

class _PassoDadosState extends ConsumerState<PassoDados> {
  late final TextEditingController _nome;
  late final TextEditingController _telefone;
  late final TextEditingController _bairro;

  @override
  void initState() {
    super.initState();
    final estado = ref.read(cadastroControladorProvider);
    _nome = TextEditingController(text: estado.nome);
    _telefone = TextEditingController(text: estado.telefone);
    _bairro = TextEditingController(text: estado.bairro);
  }

  @override
  void dispose() {
    _nome.dispose();
    _telefone.dispose();
    _bairro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final erros = ref.watch(
      cadastroControladorProvider.select((estado) => estado.erros),
    );
    final controlador = ref.read(cadastroControladorProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CabecalhoPasso(
          total: CadastroEstado.totalPassos,
          actual: PassoCadastro.dados.index,
          titulo: 'Os seus dados',
          apoio:
              'É por aqui que os clientes o contactam depois de o escolherem.',
        ),
        const SizedBox(height: Dimensoes.espaco32),
        CampoTexto(
          etiqueta: 'Nome completo',
          controlador: _nome,
          dica: 'Como está no BI',
          erro: erros['nome'],
          tipoTeclado: TextInputType.name,
          autofoco: true,
          aoAlterar: controlador.definirNome,
        ),
        const SizedBox(height: Dimensoes.espaco20),
        CampoTexto(
          etiqueta: 'Número de telefone',
          controlador: _telefone,
          dica: '84 123 4567',
          prefixo: '+258',
          erro: erros['telefone'],
          auxiliar: 'Use o número que atende durante o dia.',
          tipoTeclado: TextInputType.phone,
          maxLength: 9,
          formatadores: [FilteringTextInputFormatter.digitsOnly],
          aoAlterar: controlador.definirTelefone,
        ),
        const SizedBox(height: Dimensoes.espaco20),
        CampoTexto(
          etiqueta: 'Bairro onde vive',
          controlador: _bairro,
          dica: 'Ex.: Malhangalene',
          erro: erros['bairro'],
          acaoTeclado: TextInputAction.done,
          aoAlterar: controlador.definirBairro,
        ),
      ],
    );
  }
}
