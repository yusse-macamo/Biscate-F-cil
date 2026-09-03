import 'package:flutter/material.dart';

/// Escala tipográfica da aplicação.
///
/// Usa a fonte do sistema de propósito: o público-alvo tem dados móveis caros e
/// aparelhos modestos, e uma fonte remota atrasaria o primeiro arranque. Para
/// trocar por uma fonte própria, basta declarar `fontFamily` aqui e no
/// `pubspec.yaml`; nenhum ecrã precisa de mudar.
abstract final class Tipografia {
  static const String? familia = null;

  static TextTheme escala(Color tinta, Color tintaSuave) {
    return TextTheme(
      // Títulos de ecrã.
      headlineMedium: TextStyle(
        fontFamily: familia,
        fontSize: 26,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: tinta,
      ),
      headlineSmall: TextStyle(
        fontFamily: familia,
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: tinta,
      ),
      // Títulos de secção e de item.
      titleMedium: TextStyle(
        fontFamily: familia,
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: tinta,
      ),
      titleSmall: TextStyle(
        fontFamily: familia,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: tinta,
      ),
      // Corpo.
      bodyLarge: TextStyle(
        fontFamily: familia,
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: tinta,
      ),
      bodyMedium: TextStyle(
        fontFamily: familia,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: tintaSuave,
      ),
      bodySmall: TextStyle(
        fontFamily: familia,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: tintaSuave,
      ),
      // Botões.
      labelLarge: TextStyle(
        fontFamily: familia,
        fontSize: 16,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: tinta,
      ),
      // Micro-etiquetas em maiúsculas ("PASSO 2 DE 4").
      labelSmall: TextStyle(
        fontFamily: familia,
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: tintaSuave,
      ),
    );
  }
}
