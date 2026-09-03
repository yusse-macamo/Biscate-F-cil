/// Escala de espaçamentos, raios e medidas fixas da aplicação.
///
/// Os espaçamentos são múltiplos de 4, para manter o ritmo vertical e
/// horizontal consistente entre ecrãs.
abstract final class Dimensoes {
  static const double espaco4 = 4;
  static const double espaco8 = 8;
  static const double espaco12 = 12;
  static const double espaco16 = 16;
  static const double espaco20 = 20;
  static const double espaco24 = 24;
  static const double espaco32 = 32;
  static const double espaco40 = 40;

  static const double margemEcra = 20;
  static const double raioPequeno = 10;
  static const double raioMedio = 14;
  static const double raioGrande = 20;
  static const double alturaBotao = 52;
  static const double alturaCampo = 56;
  static const double larguraMaximaConteudo = 480;
  static const double alvoMinimoToque = 48;
}
