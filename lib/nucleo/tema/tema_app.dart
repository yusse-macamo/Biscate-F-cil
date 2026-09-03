import 'package:flutter/material.dart';

import 'cores_app.dart';
import 'dimensoes.dart';
import 'tipografia.dart';

/// Tema único da aplicação. Estilos de botão, campo e cartão vivem aqui, para
/// que os ecrãs não repitam decoração.
abstract final class TemaApp {
  static ThemeData get claro => _construir(
        esquema: CoresApp.esquemaClaro,
        fundo: CoresApp.fundo,
        superficieAlt: CoresApp.superficieAlt,
        tinta: CoresApp.tinta,
        tintaSuave: CoresApp.tintaSuave,
        tintaFraca: CoresApp.tintaFraca,
        primariaPremida: CoresApp.primariaPremida,
      );

  static ThemeData get escuro => _construir(
        esquema: CoresApp.esquemaEscuro,
        fundo: CoresApp.fundoEscuro,
        superficieAlt: CoresApp.superficieAltEscura,
        tinta: CoresApp.tintaEscura,
        tintaSuave: CoresApp.tintaSuaveEscura,
        tintaFraca: CoresApp.tintaFracaEscura,
        primariaPremida: CoresApp.primariaPremidaEscura,
      );

  static ThemeData _construir({
    required ColorScheme esquema,
    required Color fundo,
    required Color superficieAlt,
    required Color tinta,
    required Color tintaSuave,
    required Color tintaFraca,
    required Color primariaPremida,
  }) {
    final texto = Tipografia.escala(tinta, tintaSuave);

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: fundo,
      textTheme: texto,
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: texto.titleMedium,
        iconTheme: IconThemeData(color: tinta, size: 22),
      ),

      // ---- Campos de texto ---------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: esquema.surface,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensoes.espaco16,
          vertical: Dimensoes.espaco16,
        ),
        hintStyle: texto.bodyLarge?.copyWith(color: tintaFraca),
        prefixStyle: texto.bodyLarge?.copyWith(color: tintaSuave),
        errorStyle: texto.bodySmall?.copyWith(
          color: esquema.error,
          fontWeight: FontWeight.w500,
        ),
        border: _contornoCampo(esquema.outline),
        enabledBorder: _contornoCampo(esquema.outline),
        focusedBorder: _contornoCampo(esquema.primary, largura: 2),
        errorBorder: _contornoCampo(esquema.error),
        focusedErrorBorder: _contornoCampo(esquema.error, largura: 2),
        disabledBorder: _contornoCampo(esquema.outline.withValues(alpha: 0.5)),
      ),

      // ---- Botão principal ---------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(Dimensoes.alturaBotao),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.disabled)) {
              return esquema.primary.withValues(alpha: 0.35);
            }
            if (estados.contains(WidgetState.pressed)) return primariaPremida;
            return esquema.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(esquema.onPrimary),
          overlayColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.hovered)) {
              return Colors.white.withValues(alpha: 0.08);
            }
            if (estados.contains(WidgetState.focused)) {
              return Colors.white.withValues(alpha: 0.12);
            }
            return null;
          }),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(texto.labelLarge),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
            ),
          ),
        ),
      ),

      // ---- Botão secundário --------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimensoes.alvoMinimoToque),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.pressed)) return primariaPremida;
            return esquema.primary;
          }),
          textStyle: WidgetStatePropertyAll(texto.labelLarge),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
            ),
          ),
        ),
      ),

      // ---- Cartões (usados só onde há mesmo um objecto) ----------------------
      cardTheme: CardThemeData(
        color: esquema.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          side: BorderSide(color: esquema.outline),
        ),
      ),

      // ---- Chips (zonas de atendimento) --------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: esquema.surface,
        selectedColor: esquema.primaryContainer,
        checkmarkColor: esquema.onPrimaryContainer,
        labelStyle: texto.titleSmall,
        secondaryLabelStyle: texto.titleSmall,
        side: BorderSide(color: esquema.outline),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensoes.espaco12,
          vertical: Dimensoes.espaco12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
        ),
        showCheckmark: true,
      ),

      dividerTheme: DividerThemeData(
        color: esquema.outline,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tinta,
        contentTextStyle: texto.bodyMedium?.copyWith(color: fundo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
        ),
      ),

      extensions: <ThemeExtension<dynamic>>[
        SuperficiesApp(alternativa: superficieAlt, tintaFraca: tintaFraca),
      ],
    );
  }

  static OutlineInputBorder _contornoCampo(Color cor, {double largura = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }
}

/// Tons que o [ColorScheme] não cobre bem e que vários widgets precisam.
class SuperficiesApp extends ThemeExtension<SuperficiesApp> {
  const SuperficiesApp({required this.alternativa, required this.tintaFraca});

  final Color alternativa;
  final Color tintaFraca;

  static SuperficiesApp de(BuildContext context) =>
      Theme.of(context).extension<SuperficiesApp>()!;

  @override
  SuperficiesApp copyWith({Color? alternativa, Color? tintaFraca}) =>
      SuperficiesApp(
        alternativa: alternativa ?? this.alternativa,
        tintaFraca: tintaFraca ?? this.tintaFraca,
      );

  @override
  SuperficiesApp lerp(ThemeExtension<SuperficiesApp>? outro, double t) {
    if (outro is! SuperficiesApp) return this;
    return SuperficiesApp(
      alternativa: Color.lerp(alternativa, outro.alternativa, t)!,
      tintaFraca: Color.lerp(tintaFraca, outro.tintaFraca, t)!,
    );
  }
}
