# Projecto: app de prestadores de serviços

## Convenções
- Pastas, classes e variáveis em português.
- Feature first: nucleo/, comum/, funcionalidades/<nome>/{dados,dominio,apresentacao}.
- Riverpod para estado, GoRouter para navegação.
- Proibido declarar cores, paddings ou tamanhos nos ecrãs.
  Tudo vem de nucleo/tema/ (CoresApp, Dimensoes, Tipografia, TemaApp).
- Widgets só sobem para comum/ quando forem usados por duas funcionalidades.
- Validação e regras no controlador, nunca no widget.

## Estado actual
- Ecrã de cadastro do prestador (4 passos) feito, com dados falsos.
- Sem backend ligado. Supabase entra depois.

## Fora de âmbito
- Chat interno. Não implementar.