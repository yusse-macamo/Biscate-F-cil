import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Campo de texto com etiqueta fora do campo, sempre visível.
///
/// Ao contrário do rótulo flutuante, que fica minúsculo e ilegível ao
/// sol — que é onde esta app vai ser usada.
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
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: tema.textTheme.titleSmall),
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
          cursorWidth: 1.6,
          decoration: InputDecoration(
            hintText: dica,
            prefixText: prefixo,
            helperText: erro == null ? auxiliar : null,
            errorText: erro,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
