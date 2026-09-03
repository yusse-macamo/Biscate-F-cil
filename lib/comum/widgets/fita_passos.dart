import 'package:flutter/material.dart';

import '../../nucleo/tema/dimensoes.dart';

/// Indicador de progresso em passos, desenhado como fita métrica — o
/// instrumento de quem trabalha nestes ofícios. É o único gesto
/// decorativo do ecrã de cadastro; tudo o resto é sóbrio.
class FitaPassos extends StatelessWidget {
  const FitaPassos({super.key, required this.total, required this.passoAtual});

  final int total;
  final int passoAtual;

  static const double _altura = 34;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corPercorrida = tema.colorScheme.primary;
    final corRestante = tema.colorScheme.outline;
    final corMarcaRestante = tema.colorScheme.outlineVariant;

    return Semantics(
      label: 'Passo ${passoAtual + 1} de $total',
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: passoAtual.toDouble()),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        builder: (context, progresso, _) {
          return CustomPaint(
            size: const Size(double.infinity, _altura),
            painter: _PintorFitaPassos(
              total: total,
              progresso: progresso,
              corPercorrida: corPercorrida,
              corRestante: corRestante,
              corMarcaRestante: corMarcaRestante,
            ),
          );
        },
      ),
    );
  }
}

class _PintorFitaPassos extends CustomPainter {
  _PintorFitaPassos({
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

  @override
  void paint(Canvas canvas, Size size) {
    final largura = size.width;
    final baseY = size.height - 18;
    final larguraPasso = total > 1 ? largura / (total - 1) : largura;
    final xPercorrido = (larguraPasso * progresso).clamp(0, largura).toDouble();

    final trilho = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    trilho.color = corRestante;
    canvas.drawLine(Offset(0, baseY), Offset(largura, baseY), trilho);

    if (xPercorrido > 0) {
      trilho.color = corPercorrida;
      canvas.drawLine(Offset(0, baseY), Offset(xPercorrido, baseY), trilho);
    }

    final marcaMenor = Paint()..strokeWidth = 1.4;
    for (double x = 0; x <= largura; x += 7) {
      final passou = x <= xPercorrido;
      marcaMenor.color =
          passou ? corPercorrida.withValues(alpha: 0.55) : corMarcaRestante;
      canvas.drawLine(Offset(x, baseY + 4), Offset(x, baseY + 10), marcaMenor);
    }

    final marcaMaior = Paint()..strokeWidth = 2.4;
    for (var i = 0; i < total; i++) {
      final x = larguraPasso * i;
      marcaMaior.color =
          i <= progresso.round() ? corPercorrida : corMarcaRestante;
      canvas.drawLine(Offset(x, baseY - 14), Offset(x, baseY), marcaMaior);
    }

    canvas.drawCircle(Offset(xPercorrido, baseY), 5, Paint()..color = corPercorrida);
  }

  @override
  bool shouldRepaint(covariant _PintorFitaPassos oldDelegate) {
    return oldDelegate.progresso != progresso ||
        oldDelegate.total != total ||
        oldDelegate.corPercorrida != corPercorrida;
  }
}

/// Cabeçalho dos passos do cadastro: legenda "PASSO X DE Y", fita de
/// progresso, título e texto de apoio.
class CabecalhoPasso extends StatelessWidget {
  const CabecalhoPasso({
    super.key,
    required this.total,
    required this.atual,
    required this.titulo,
    required this.apoio,
  });

  final int total;
  final int atual;
  final String titulo;
  final String apoio;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PASSO ${atual + 1} DE $total', style: tema.textTheme.labelSmall),
        const SizedBox(height: Dimensoes.espaco8),
        FitaPassos(total: total, passoAtual: atual),
        const SizedBox(height: Dimensoes.espaco20),
        Text(titulo, style: tema.textTheme.headlineMedium),
        const SizedBox(height: Dimensoes.espaco8),
        Text(apoio, style: tema.textTheme.bodyMedium),
      ],
    );
  }
}
