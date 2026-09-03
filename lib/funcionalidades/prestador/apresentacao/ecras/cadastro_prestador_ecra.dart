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

/// Ecrã de cadastro do prestador, em quatro passos. Não guarda dados
/// nem valida nada — isso é tudo do controlador.
class CadastroPrestadorEcra extends ConsumerWidget {
  const CadastroPrestadorEcra({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cadastroControladorProvider);
    final controlador = ref.read(cadastroControladorProvider.notifier);

    final passo = estado.passo;
    final noPrimeiroPasso = passo == PassoCadastro.dados;
    final naAprovacao = passo == PassoCadastro.aprovacao;
    final mostrarSeta =
        passo == PassoCadastro.categoria || passo == PassoCadastro.documentos;

    return PopScope(
      canPop: noPrimeiroPasso,
      onPopInvokedWithResult: (didPop, resultado) {
        if (!didPop) controlador.recuar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: naAprovacao ? null : const Text('Registar-se como prestador'),
          automaticallyImplyLeading: false,
          leading: mostrarSeta
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: controlador.recuar,
                )
              : null,
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, restricoes) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: Dimensoes.margemEcra,
                  right: Dimensoes.margemEcra,
                  top: Dimensoes.espaco8,
                  bottom: Dimensoes.espaco32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: restricoes.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: Dimensoes.larguraMaximaConteudo,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, animation) {
                            final deslocamento = Tween<Offset>(
                              begin: const Offset(0, 0.03),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: deslocamento,
                                child: child,
                              ),
                            );
                          },
                          child: KeyedSubtree(
                            key: ValueKey(passo),
                            child: switch (passo) {
                              PassoCadastro.dados => const PassoDados(),
                              PassoCadastro.categoria => const PassoCategoria(),
                              PassoCadastro.documentos => const PassoDocumentos(),
                              PassoCadastro.aprovacao => const PassoAprovacao(),
                            },
                          ),
                        ),
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
            rotulo: switch (passo) {
              PassoCadastro.dados || PassoCadastro.categoria => 'Continuar',
              PassoCadastro.documentos => 'Enviar cadastro',
              PassoCadastro.aprovacao => 'Concluir',
            },
            icone: naAprovacao ? null : Icons.arrow_forward_rounded,
            carregando: estado.aEnviar,
            aoTocar: () {
              FocusScope.of(context).unfocus();
              if (naAprovacao) {
                // TODO: navegar ao painel do prestador via GoRouter.
                return;
              }
              controlador.avancar();
            },
          ),
          secundaria: passo == PassoCadastro.documentos
              ? TextButton(
                  onPressed: controlador.recuar,
                  child: const Text('Voltar'),
                )
              : null,
        ),
      ),
    );
  }
}
