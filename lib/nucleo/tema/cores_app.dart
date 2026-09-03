import 'package:flutter/material.dart';

/// Paleta única da aplicação.
///
/// Nenhum ecrã deve declarar cores directamente: ou vem do [Theme] ou vem
/// daqui através do [ColorScheme].
abstract final class CoresApp {
  // ---- Tema claro ----------------------------------------------------------
  static const Color fundo = Color(0xFFF6F7F6);
  static const Color superficie = Color(0xFFFFFFFF);
  static const Color superficieAlt = Color(0xFFEFF2F1);

  static const Color tinta = Color(0xFF101715);
  static const Color tintaSuave = Color(0xFF5D6B67);
  static const Color tintaFraca = Color(0xFF8A9793);

  static const Color primaria = Color(0xFF0E5F58);
  static const Color primariaPremida = Color(0xFF0A4741);
  static const Color primariaSuave = Color(0xFFE3EEEC);

  static const Color contorno = Color(0xFFDCE3E1);
  static const Color contornoForte = Color(0xFFC3CDCA);

  static const Color erro = Color(0xFFA3231C);
  static const Color erroSuave = Color(0xFFFBECEB);
  static const Color sucesso = Color(0xFF1B6E42);

  // ---- Tema escuro ---------------------------------------------------------
  static const Color fundoEscuro = Color(0xFF0E1211);
  static const Color superficieEscura = Color(0xFF161B1A);
  static const Color superficieAltEscura = Color(0xFF1E2523);

  static const Color tintaEscura = Color(0xFFE8EDEB);
  static const Color tintaSuaveEscura = Color(0xFF9AA8A4);
  static const Color tintaFracaEscura = Color(0xFF6D7B77);

  static const Color primariaEscura = Color(0xFF4FB3A6);
  static const Color primariaPremidaEscura = Color(0xFF3E9A8E);
  static const Color primariaSuaveEscura = Color(0xFF16302D);

  static const Color contornoEscuro = Color(0xFF2A322F);
  static const Color contornoForteEscuro = Color(0xFF3A4441);

  static const Color erroEscuro = Color(0xFFE8776F);
  static const Color erroSuaveEscuro = Color(0xFF2A1917);
  static const Color sucessoEscuro = Color(0xFF4CAF7D);

  static const ColorScheme esquemaClaro = ColorScheme.light(
    primary: primaria,
    onPrimary: Colors.white,
    primaryContainer: primariaSuave,
    onPrimaryContainer: primariaPremida,
    secondary: primaria,
    onSecondary: Colors.white,
    surface: superficie,
    onSurface: tinta,
    error: erro,
    onError: Colors.white,
    errorContainer: erroSuave,
    onErrorContainer: erro,
    outline: contorno,
    outlineVariant: contornoForte,
  );

  static const ColorScheme esquemaEscuro = ColorScheme.dark(
    primary: primariaEscura,
    onPrimary: Color(0xFF04211E),
    primaryContainer: primariaSuaveEscura,
    onPrimaryContainer: primariaEscura,
    secondary: primariaEscura,
    onSecondary: Color(0xFF04211E),
    surface: superficieEscura,
    onSurface: tintaEscura,
    error: erroEscuro,
    onError: Color(0xFF2A0F0D),
    errorContainer: erroSuaveEscuro,
    onErrorContainer: erroEscuro,
    outline: contornoEscuro,
    outlineVariant: contornoForteEscuro,
  );
}
