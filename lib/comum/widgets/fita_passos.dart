import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Indicador de progresso desenhado como uma fita métrica.
///
/// Escolhido por ser o instrumento de quem trabalha nestes ofícios e por a
/// escala mostrar mesmo uma sequência: cada marca maior é um passo do cadastro.
class FitaPassos extends StatelessWidget {
  const FitaPassos({
    super.key,
    required this.total,
    required this.actual,
  }) : assert(total > 0);

  /// Número total de passos.
  final int total;

  /// Passo actual, começando em 0.
  final int actual;

  static const double _altura = 34;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Passo ${actual + 1} de $total',
      child: SizedBox(
        height: _altura,
        width: double.infinity,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: actual.toDouble()),
          builder: (context, progresso, _) => CustomPaint(
            painter: _PintorFita(
              total: total,
              progresso: progresso,
              corPercorrida: esquema.primary,
              corRestante: esquema.outline,
              corMarcaRestante: esquema.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _PintorFita extends CustomPainter {
  _PintorFita({
    required this.total,
    required this.progresso,
    required this.corPercorrida,
    required this.corRestante,
    required this.corMarcaRestante,
  });

  final int total;
  final double progresso;
  final Color corPercorrida;
  final Color corRestante;
  final Color corMarcaRestante;

  static const double _espacoMarcas = 7;
  static const double _alturaMarcaMenor = 6;
  static const double _alturaMarcaMaior = 14;
  static const double _espessuraRail = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height - _alturaMarcaMaior - 4;
    final passoLargura = size.width / (total - 1 == 0 ? 1 : total - 1);
    final xProgresso = total == 1 ? size.width : passoLargura * progresso;

    // Trilho de fundo.
    final rail = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _espessuraRail
      ..color = corRestante;
    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY), rail);

    // Trilho percorrido.
    rail.color = corPercorrida;
    canvas.drawLine(
      Offset(0, baseY),
      Offset(xProgresso.clamp(0.0, size.width), baseY),
      rail,
    );

    // Marcas menores de escala.
    final marca = Paint()..strokeWidth = 1.4;
    for (double x = 0; x <= size.width; x += _espacoMarcas) {
      marca.color = x <= xProgresso
          ? corPercorrida.withValues(alpha: 0.55)
          : corMarcaRestante;
      canvas.drawLine(
        Offset(x, baseY + 4),
        Offset(x, baseY + 4 + _alturaMarcaMenor),
        marca,
      );
    }

    // Marcas maiores: uma por passo.
    final marcaPasso = Paint()
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < total; i++) {
      final x = (passoLargura * i).clamp(1.2, size.width - 1.2);
      final concluido = i <= progresso.round();
      marcaPasso.color = concluido ? corPercorrida : corMarcaRestante;
      canvas.drawLine(
        Offset(x, baseY + 4),
        Offset(x, baseY + 4 + _alturaMarcaMaior),
        marcaPasso,
      );
    }

    // Cursor do passo actual.
    final cursor = Paint()..color = corPercorrida;
    canvas.drawCircle(Offset(xProgresso.clamp(0.0, size.width), baseY), 5, cursor);
  }

  @override
  bool shouldRepaint(_PintorFita anterior) =>
      anterior.progresso != progresso ||
      anterior.total != total ||
      anterior.corPercorrida != corPercorrida;
}

/// Cabeçalho de passo: micro-etiqueta, fita, título e apoio.
class CabecalhoPasso extends StatelessWidget {
  const CabecalhoPasso({
    super.key,
    required this.total,
    required this.actual,
    required this.titulo,
    required this.apoio,
  });

  final int total;
  final int actual;
  final String titulo;
  final String apoio;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PASSO ${actual + 1} DE $total', style: texto.labelSmall),
        const SizedBox(height: Dimensoes.espaco8),
        FitaPassos(total: total, actual: actual),
        const SizedBox(height: Dimensoes.espaco20),
        Text(titulo, style: texto.headlineMedium),
        const SizedBox(height: Dimensoes.espaco8),
        Text(apoio, style: texto.bodyMedium),
      ],
    );
  }
}
