/// Escala única de espaçamento e forma.
///
/// Todos os múltiplos são de 4. Não usar valores soltos nos ecrãs.
abstract final class Dimensoes {
  static const double espaco4 = 4;
  static const double espaco8 = 8;
  static const double espaco12 = 12;
  static const double espaco16 = 16;
  static const double espaco20 = 20;
  static const double espaco24 = 24;
  static const double espaco32 = 32;
  static const double espaco40 = 40;

  /// Margem lateral do conteúdo em telemóvel.
  static const double margemEcra = espaco20;

  static const double raioPequeno = 10;
  static const double raioMedio = 14;
  static const double raioGrande = 20;

  static const double alturaBotao = 52;
  static const double alturaCampo = 56;

  /// Acima disto o conteúdo deixa de esticar e centra-se (tablet).
  static const double larguraMaximaConteudo = 480;

  /// Área mínima tocável recomendada.
  static const double alvoMinimoToque = 48;
}
