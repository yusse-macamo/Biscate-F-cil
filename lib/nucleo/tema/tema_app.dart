import 'package:flutter/material.dart';

import 'cores_app.dart';
import 'dimensoes.dart';
import 'tipografia.dart';

/// Temas claro e escuro da aplicação: `ThemeData` com os estilos de
/// campo, botão, chip, cartão e barra de topo já configurados.
abstract final class TemaApp {
  static final ThemeData claro = _construir(
    esquema: CoresApp.esquemaClaro,
    fundo: CoresApp.fundo,
    superficie: CoresApp.superficie,
    superficieAlt: CoresApp.superficieAlt,
    tinta: CoresApp.tinta,
    tintaSuave: CoresApp.tintaSuave,
    tintaFraca: CoresApp.tintaFraca,
    primariaPremida: CoresApp.primariaPremida,
  );

  static final ThemeData escuro = _construir(
    esquema: CoresApp.esquemaEscuro,
    fundo: CoresApp.fundoEscuro,
    superficie: CoresApp.superficieEscura,
    superficieAlt: CoresApp.superficieAltEscura,
    tinta: CoresApp.tintaEscura,
    tintaSuave: CoresApp.tintaSuaveEscura,
    tintaFraca: CoresApp.tintaFracaEscura,
    primariaPremida: CoresApp.primariaPremidaEscura,
  );

  static ThemeData _construir({
    required ColorScheme esquema,
    required Color fundo,
    required Color superficie,
    required Color superficieAlt,
    required Color tinta,
    required Color tintaSuave,
    required Color tintaFraca,
    required Color primariaPremida,
  }) {
    final textTheme = Tipografia.escala(tinta, tintaSuave);

    final bordaNormal = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
      borderSide: BorderSide(color: esquema.outline),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: esquema.brightness,
      colorScheme: esquema,
      scaffoldBackgroundColor: fundo,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      extensions: [
        SuperficiesApp(alternativa: superficieAlt, tintaFraca: tintaFraca),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        foregroundColor: tinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensoes.espaco16,
          vertical: Dimensoes.espaco16,
        ),
        border: bordaNormal,
        enabledBorder: bordaNormal,
        focusedBorder: bordaNormal.copyWith(
          borderSide: BorderSide(color: esquema.primary, width: 2),
        ),
        errorBorder: bordaNormal.copyWith(
          borderSide: BorderSide(color: esquema.error, width: 1),
        ),
        focusedErrorBorder: bordaNormal.copyWith(
          borderSide: BorderSide(color: esquema.error, width: 2),
        ),
        disabledBorder: bordaNormal.copyWith(
          borderSide: BorderSide(color: esquema.outline.withValues(alpha: 0.5)),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: esquema.error,
          fontWeight: FontWeight.w500,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(Dimensoes.alturaBotao),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStatePropertyAll(esquema.onPrimary),
          backgroundColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.disabled)) {
              return esquema.primary.withValues(alpha: 0.35);
            }
            if (estados.contains(WidgetState.pressed)) {
              return primariaPremida;
            }
            return esquema.primary;
          }),
          overlayColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.hovered)) {
              return Colors.white.withValues(alpha: 0.08);
            }
            if (estados.contains(WidgetState.focused) ||
                estados.contains(WidgetState.pressed)) {
              return Colors.white.withValues(alpha: 0.12);
            }
            return null;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, Dimensoes.alvoMinimoToque),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.pressed)) return primariaPremida;
            return esquema.primary;
          }),
        ),
      ),
      cardTheme: CardThemeData(
        color: superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensoes.raioMedio),
          side: BorderSide(color: esquema.outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: superficie,
        selectedColor: esquema.primaryContainer,
        checkmarkColor: esquema.onPrimaryContainer,
        labelStyle: textTheme.titleSmall,
        side: BorderSide(color: esquema.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensoes.raioPequeno),
        ),
        padding: const EdgeInsets.all(Dimensoes.espaco12),
      ),
      dividerTheme: DividerThemeData(color: esquema.outline, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tinta,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: fundo),
      ),
    );
  }
}

/// Tons de superfície que o `ColorScheme` não cobre bem: uma superfície
/// alternativa (para distinguir secções sem usar contraste forte) e um
/// tom de tinta mais fraco que o `onSurfaceVariant` padrão.
@immutable
class SuperficiesApp extends ThemeExtension<SuperficiesApp> {
  const SuperficiesApp({required this.alternativa, required this.tintaFraca});

  final Color alternativa;
  final Color tintaFraca;

  static SuperficiesApp de(BuildContext context) {
    return Theme.of(context).extension<SuperficiesApp>()!;
  }

  @override
  SuperficiesApp copyWith({Color? alternativa, Color? tintaFraca}) {
    return SuperficiesApp(
      alternativa: alternativa ?? this.alternativa,
      tintaFraca: tintaFraca ?? this.tintaFraca,
    );
  }

  @override
  SuperficiesApp lerp(ThemeExtension<SuperficiesApp>? other, double t) {
    if (other is! SuperficiesApp) return this;
    return SuperficiesApp(
      alternativa: Color.lerp(alternativa, other.alternativa, t)!,
      tintaFraca: Color.lerp(tintaFraca, other.tintaFraca, t)!,
    );
  }
}
