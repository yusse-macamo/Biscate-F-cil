import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../comum/widgets/barra_accoes.dart';
import '../../../../comum/widgets/botao_principal.dart';
import '../../../../nucleo/tema/dimensoes.dart';
import '../controladores/cadastro_controlador.dart';
import '../controladores/cadastro_estado.dart';
import '../widgets/passo_aprovacao.dart';
import '../widgets/passo_categoria.dart';
import '../widgets/passo_dados.dart';
import '../widgets/passo_documentos.dart';

/// Cadastro do prestador em quatro passos.
///
/// O ecrã não guarda dados nem valida nada: lê o estado e chama o controlador.
class CadastroPrestadorEcra extends ConsumerWidget {
  const CadastroPrestadorEcra({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);
    final noFim = estado.passo == PassoCadastro.aprovacao;

    return PopScope(
      canPop: estado.passo == PassoCadastro.dados,
      onPopInvokedWithResult: (saiu, _) {
        if (!saiu) controlador.recuar();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: estado.passo == PassoCadastro.dados || noFim
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Voltar',
                  onPressed: controlador.recuar,
                ),
          title: Text(noFim ? '' : 'Registar-se como prestador'),
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, restricoes) {
              // Em tablet o formulário deixa de esticar e centra-se.
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Dimensoes.margemEcra,
                  Dimensoes.espaco8,
                  Dimensoes.margemEcra,
                  Dimensoes.espaco32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Dimensoes.larguraMaximaConteudo,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (filho, animacao) => FadeTransition(
                        opacity: animacao,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.03),
                            end: Offset.zero,
                          ).animate(animacao),
                          child: filho,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(estado.passo),
                        child: switch (estado.passo) {
                          PassoCadastro.dados => const PassoDados(),
                          PassoCadastro.categoria => const PassoCategoria(),
                          PassoCadastro.documentos => const PassoDocumentos(),
                          PassoCadastro.aprovacao => const PassoAprovacao(),
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BarraAccoes(
          principal: BotaoPrincipal(
            rotulo: switch (estado.passo) {
              PassoCadastro.documentos => 'Enviar cadastro',
              PassoCadastro.aprovacao => 'Concluir',
              _ => 'Continuar',
            },
            carregando: estado.aEnviar,
            icone: noFim ? null : Icons.arrow_forward_rounded,
            aoTocar: () async {
              if (noFim) {
                // TODO(navegacao): ir para o painel do prestador (GoRouter).
                return;
              }
              FocusScope.of(context).unfocus();
              await controlador.avancar();
            },
          ),
          secundaria: estado.passo == PassoCadastro.documentos
              ? TextButton(
                  onPressed:
                      estado.aEnviar ? null : () => controlador.recuar(),
                  child: const Text('Voltar'),
                )
              : null,
        ),
      ),
    );
  }
}
