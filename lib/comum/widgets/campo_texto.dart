import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Campo de texto com etiqueta acima, estado de foco e mensagem de erro.
///
/// A etiqueta fica fora do campo (e não flutuante) porque se mantém legível com
/// o campo preenchido, o que ajuda quem preenche formulários longos ao sol.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.dica,
    this.auxiliar,
    this.erro,
    this.prefixo,
    this.tipoTeclado,
    this.acaoTeclado = TextInputAction.next,
    this.formatadores,
    this.maxLength,
    this.autofoco = false,
    this.aoAlterar,
    this.aoSubmeter,
  });

  final String etiqueta;
  final TextEditingController controlador;
  final String? dica;

  /// Texto de apoio permanente, escondido enquanto houver erro.
  final String? auxiliar;
  final String? erro;
  final String? prefixo;
  final TextInputType? tipoTeclado;
  final TextInputAction acaoTeclado;
  final List<TextInputFormatter>? formatadores;
  final int? maxLength;
  final bool autofoco;
  final ValueChanged<String>? aoAlterar;
  final ValueChanged<String>? aoSubmeter;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: texto.titleSmall),
        const SizedBox(height: Dimensoes.espaco8),
        TextField(
          controller: controlador,
          keyboardType: tipoTeclado,
          textInputAction: acaoTeclado,
          inputFormatters: formatadores,
          maxLength: maxLength,
          autofocus: autofoco,
          onChanged: aoAlterar,
          onSubmitted: aoSubmeter,
          style: texto.bodyLarge,
          cursorWidth: 1.6,
          decoration: InputDecoration(
            hintText: dica,
            errorText: erro,
            helperText: erro == null ? auxiliar : null,
            helperStyle: texto.bodySmall,
            counterText: '',
            prefixIcon: prefixo == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensoes.espaco16,
                      right: Dimensoes.espaco8,
                    ),
                    child: Text(prefixo!, style: texto.bodyLarge),
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
        ),
      ],
    );
  }
}
