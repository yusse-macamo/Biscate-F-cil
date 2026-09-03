# Especificação: ecrã de cadastro do prestador

App Flutter de ligação entre prestadores de serviços e clientes (Maputo e
Matola). Este documento descreve, ao detalhe, o que construir. Segue-o à letra;
onde não estiver especificado, decide com o mesmo critério do resto.

Stack: Flutter 3.27+, Dart 3, Material 3, Riverpod (`flutter_riverpod ^2.5.1`).
Sem backend nesta fase: dados falsos e submissão simulada.

---

## 1. Regras gerais

- Pastas, ficheiros, classes e variáveis em português. Ficheiros em `snake_case`.
- Feature first: `nucleo/`, `comum/`, `funcionalidades/<nome>/{dados,dominio,apresentacao}`.
- **Nenhuma cor, padding, raio ou tamanho de letra declarado nos ecrãs.** Tudo
  vem de `nucleo/tema/`. Se um ecrã precisa de um valor novo, acrescenta-se à
  escala, não se escreve no local.
- Validação e regras de negócio no controlador. Widgets só leem estado e chamam
  métodos.
- `const` em todo o widget que o permita.
- `SafeArea` no corpo e na barra de fundo.
- Um widget por ficheiro público.

## 2. Estrutura de ficheiros

```
lib/
├── main.dart
├── nucleo/tema/
│   ├── cores_app.dart
│   ├── dimensoes.dart
│   ├── tipografia.dart
│   └── tema_app.dart
├── comum/widgets/
│   ├── fita_passos.dart          (FitaPassos + CabecalhoPasso)
│   ├── campo_texto.dart
│   ├── botao_principal.dart
│   ├── linha_opcao.dart
│   ├── cartao_documento.dart
│   └── barra_accoes.dart
└── funcionalidades/prestador/
    ├── dados/dados_falsos.dart
    └── apresentacao/
        ├── controladores/
        │   ├── cadastro_estado.dart
        │   └── cadastro_controlador.dart
        ├── ecras/cadastro_prestador_ecra.dart
        └── widgets/
            ├── passo_dados.dart
            ├── passo_categoria.dart
            ├── passo_documentos.dart
            └── passo_aprovacao.dart
```

---

## 3. Tema

### 3.1 `cores_app.dart`

Classe `abstract final class CoresApp` com constantes e dois `ColorScheme`
(`esquemaClaro`, `esquemaEscuro`).

Tema claro:

| Token | Hex |
|---|---|
| fundo | `#F6F7F6` |
| superficie | `#FFFFFF` |
| superficieAlt | `#EFF2F1` |
| tinta | `#101715` |
| tintaSuave | `#5D6B67` |
| tintaFraca | `#8A9793` |
| primaria | `#0E5F58` |
| primariaPremida | `#0A4741` |
| primariaSuave | `#E3EEEC` |
| contorno | `#DCE3E1` |
| contornoForte | `#C3CDCA` |
| erro | `#A3231C` |
| erroSuave | `#FBECEB` |
| sucesso | `#1B6E42` |

Tema escuro:

| Token | Hex |
|---|---|
| fundoEscuro | `#0E1211` |
| superficieEscura | `#161B1A` |
| superficieAltEscura | `#1E2523` |
| tintaEscura | `#E8EDEB` |
| tintaSuaveEscura | `#9AA8A4` |
| tintaFracaEscura | `#6D7B77` |
| primariaEscura | `#4FB3A6` |
| primariaPremidaEscura | `#3E9A8E` |
| primariaSuaveEscura | `#16302D` |
| contornoEscuro | `#2A322F` |
| contornoForteEscuro | `#3A4441` |
| erroEscuro | `#E8776F` |
| erroSuaveEscuro | `#2A1917` |
| sucessoEscuro | `#4CAF7D` |

No `ColorScheme`: `primary` = primária, `primaryContainer` = primariaSuave,
`onPrimaryContainer` = primariaPremida, `surface` = superfície, `error` = erro,
`errorContainer` = erroSuave, `outline` = contorno, `outlineVariant` =
contornoForte.

### 3.2 `dimensoes.dart`

`abstract final class Dimensoes`. Escala múltipla de 4: `espaco4`, `espaco8`,
`espaco12`, `espaco16`, `espaco20`, `espaco24`, `espaco32`, `espaco40`.
Ainda: `margemEcra = 20`, `raioPequeno = 10`, `raioMedio = 14`,
`raioGrande = 20`, `alturaBotao = 52`, `alturaCampo = 56`,
`larguraMaximaConteudo = 480`, `alvoMinimoToque = 48`.

### 3.3 `tipografia.dart`

Fonte do sistema, sem `google_fonts` (o público tem dados caros e aparelhos
modestos; uma fonte remota atrasaria o arranque). Método
`escala(Color tinta, Color tintaSuave)` que devolve `TextTheme`:

| Papel | Tamanho | Peso | Altura | Tracking | Cor |
|---|---|---|---|---|---|
| headlineMedium | 26 | w700 | 1.2 | -0.6 | tinta |
| headlineSmall | 22 | w700 | 1.25 | -0.4 | tinta |
| titleMedium | 16 | w600 | 1.3 | -0.1 | tinta |
| titleSmall | 14 | w600 | 1.3 | 0 | tinta |
| bodyLarge | 16 | w400 | 1.45 | 0 | tinta |
| bodyMedium | 14 | w400 | 1.45 | 0 | tintaSuave |
| bodySmall | 12 | w400 | 1.4 | 0 | tintaSuave |
| labelLarge | 16 | w600 | 1.2 | 0.1 | tinta |
| labelSmall | 11 | w700 | 1.2 | 1.4 | tintaSuave |

`labelSmall` é a micro-etiqueta em maiúsculas ("PASSO 2 DE 4"); é o que dá
carácter à tipografia.

### 3.4 `tema_app.dart`

`abstract final class TemaApp` com `claro` e `escuro`, ambos de um construtor
privado partilhado. `useMaterial3: true`, `scaffoldBackgroundColor` = fundo,
`splashFactory: InkSparkle.splashFactory`.

- **AppBar**: fundo igual ao scaffold, `elevation: 0`,
  `scrolledUnderElevation: 0`, `surfaceTintColor: transparent`,
  `centerTitle: false`, título com `titleMedium`.
- **InputDecorationTheme**: `filled`, fillColor = superfície, padding 16 em
  ambos os eixos, `OutlineInputBorder` de raio médio. Contorno normal com
  `outline` a 1px; focado com `primary` a 2px; erro com `error` a 1px; erro
  focado com `error` a 2px; desactivado com `outline` a 50% de opacidade.
  `errorStyle` = bodySmall na cor de erro, peso w500.
- **FilledButtonTheme** (`ButtonStyle`, não `styleFrom`, para controlar estados):
  altura mínima `alturaBotao`, raio médio, `elevation: 0`, texto `labelLarge`.
  Fundo: `primary` normal, `primariaPremida` em `pressed`, `primary` a 35% em
  `disabled`. `overlayColor`: branco a 8% em `hovered`, a 12% em `focused`.
- **TextButtonTheme**: altura mínima `alvoMinimoToque`, cor `primary`,
  `primariaPremida` em `pressed`.
- **CardTheme** (`CardThemeData`): superfície, `elevation: 0`, sem margem,
  contorno de 1px, raio médio.
- **ChipTheme**: fundo superfície, seleccionado `primaryContainer`, checkmark
  `onPrimaryContainer`, etiqueta `titleSmall`, contorno `outline`, raio pequeno,
  padding 12.
- **DividerTheme**: cor `outline`, espessura 1.
- **SnackBarTheme**: flutuante, fundo `tinta`, texto na cor do fundo.
- **ThemeExtension `SuperficiesApp`** com `alternativa` (superficieAlt) e
  `tintaFraca`, e um `static SuperficiesApp de(BuildContext)`. Serve para os
  tons que o `ColorScheme` não cobre bem.

---

## 4. Widgets reutilizáveis (`comum/widgets/`)

### 4.1 `FitaPassos` — elemento assinatura

Indicador de progresso desenhado como **fita métrica**. É o instrumento de quem
trabalha nestes ofícios e a escala mostra mesmo uma sequência. É o único gesto
decorativo do ecrã; tudo o resto é sóbrio.

`CustomPaint` com altura fixa de 34, dentro de um `TweenAnimationBuilder`
(320 ms, `Curves.easeOutCubic`) sobre o índice do passo, para a fita deslizar
quando se avança. `Semantics(label: 'Passo X de Y')`.

O pintor recebe `total`, `progresso` (double), e três cores (percorrida,
restante, marca restante). Desenha, com `baseY = altura - 18`:

1. Trilho de fundo: linha horizontal de ponta a ponta, 3px, `strokeCap.round`,
   cor restante.
2. Trilho percorrido: mesma linha até `x = larguraPasso * progresso`, cor
   primária.
3. Marcas menores de escala: traços verticais de 6px, 1.4px de espessura, de 7
   em 7 pixéis, começando 4px abaixo do trilho. A cor é a primária a 55% se já
   passou, senão a cor de marca restante.
4. Marcas maiores: uma por passo, 14px de altura, 2.4px, nas posições
   `larguraPasso * i`, na primária se `i <= progresso.round()`.
5. Cursor: círculo de raio 5 na primária, sobre o trilho, na posição actual.

`shouldRepaint` compara progresso, total e cor.

No mesmo ficheiro, `CabecalhoPasso(total, actual, titulo, apoio)`, em coluna
alinhada à esquerda: `PASSO {actual+1} DE {total}` em `labelSmall`, espaço 8,
`FitaPassos`, espaço 20, título em `headlineMedium`, espaço 8, apoio em
`bodyMedium`.

### 4.2 `CampoTexto`

Etiqueta **fora** do campo, em `titleSmall`, e não flutuante: com o campo
preenchido, o rótulo flutuante fica minúsculo e ilegível ao sol, que é onde esta
app vai ser usada.

Parâmetros: `etiqueta`, `controlador`, `dica`, `auxiliar` (texto de apoio
permanente, escondido enquanto houver erro), `erro`, `prefixo` (texto, ex.
`+258`), `tipoTeclado`, `acaoTeclado` (por omissão `next`), `formatadores`,
`maxLength`, `autofoco`, `aoAlterar`, `aoSubmeter`. `counterText: ''` para
esconder o contador. Cursor de 1.6px. Toda a decoração vem do tema.

### 4.3 `BotaoPrincipal`

`FilledButton` com `rotulo`, `aoTocar`, `carregando`, `icone` opcional. Em
carregamento fica desactivado e mostra um `CircularProgressIndicator` de 20px
(2.2 de espessura) na cor `onPrimary`, trocado por `AnimatedSwitcher` de 180 ms
para o botão não saltar. O estilo vem do tema, não se repete aqui.

### 4.4 `LinhaOpcao`

Escolha única, em linha, com `titulo`, `descricao`, `icone`, `seleccionada`,
`aoTocar`. Substitui o rádio clássico, pequeno demais para dedos com luvas.
`Material` + `InkWell` com raio médio, `AnimatedContainer` de 160 ms: fundo
`primaryContainer` e contorno `primary` a 2px quando seleccionada, senão
superfície e contorno normal a 1px. À direita, ícone `check_circle_rounded` com
`AnimatedOpacity`. `Semantics(selected: ...)`.

### 4.5 `CartaoDocumento`

Único sítio do ecrã com cartão, porque aqui há mesmo um objecto a representar.
`titulo`, `apoio`, `icone`, `aoTocar`, `nomeFicheiro` (quando preenchido, passa
ao estado "enviado"), `aoRemover`.

Por enviar: fundo `superficieAlt`, contorno normal, quadrado de 44px com o ícone
do documento em `tintaFraca`, e um `+` à direita. Enviado: fundo superfície,
contorno `primary`, quadrado com `check_rounded` na primária, nome do ficheiro
em `bodySmall` com elipse, e botão de fechar à direita. `onTap` desactivado
quando já está enviado.

### 4.6 `BarraAccoes`

Barra fixa no fundo, com a acção principal ao alcance do polegar. Fundo igual ao
scaffold, contorno superior de 1px, `SafeArea(top: false)`, padding 20 lateral e
12 vertical, conteúdo centrado com `larguraMaximaConteudo`. Aceita `principal` e
`secundaria` opcional.

---

## 5. Dados falsos

`dados_falsos.dart` com `CategoriaFalsa(id, nome, descricao, icone)` e a lista:

| id | nome | descrição | ícone |
|---|---|---|---|
| canalizacao | Canalização | Torneiras, canos, autoclismos, fugas de água | `plumbing_rounded` |
| electricidade | Electricidade | Instalações, quadros, tomadas, iluminação | `electrical_services_rounded` |
| frio | Frio e climatização | Ar condicionado, arcas, frigoríficos | `ac_unit_rounded` |
| carpintaria | Carpintaria | Portas, armários, móveis, fechaduras | `carpenter_rounded` |

Zonas: Alto Maé, Polana, Sommerschield, Malhangalene, Maxaquene, Costa do Sol,
Laulane, Zimpeto, Matola A, Matola B, Machava, Fomento.

Comentário no topo a dizer que o catálogo definitivo entra depois por migração.

---

## 6. Estado e controlador

### 6.1 `cadastro_estado.dart`

`enum PassoCadastro { dados, categoria, documentos, aprovacao }`.

`@immutable class CadastroEstado` com: `passo`, `nome`, `telefone`, `bairro`,
`categoriaId`, `zonas` (`Set<String>`), `fotoPerfil`, `biFrente`, `biVerso`
(nomes de ficheiro), `erros` (`Map<String, String>` por campo) e `aEnviar`.

Getters: `indicePasso`, `totalPassos` (estático), `temDocumentosObrigatorios`
(foto de perfil e BI frente).

`copiarCom(...)` com flags explícitas `limparFotoPerfil`, `limparBiFrente`,
`limparBiVerso`, porque `null` num parâmetro opcional não distingue "não
mexer" de "apagar".

### 6.2 `cadastro_controlador.dart`

`NotifierProvider<CadastroControlador, CadastroEstado>` chamado
`cadastroControladorProvider`.

Métodos de campo: `definirNome`, `definirTelefone`, `definirBairro`,
`definirCategoria`, `alternarZona`, `definirFotoPerfil`, `definirBiFrente`,
`definirBiVerso`. Cada um limpa o erro do respectivo campo ao alterar o valor
(o erro reaparece só se voltar a falhar na validação).

`avancar()`: valida o passo actual; se houver erros, guarda-os e devolve
`false`. Senão avança; no passo dos documentos chama `_submeter()`.

`recuar()`: devolve `false` no primeiro passo e no de aprovação (para o ecrã
decidir se fecha), senão recua e limpa os erros.

`_submeter()`: liga `aEnviar`, espera 1200 ms (simulação), desliga e passa ao
passo de aprovação. Deixa um `TODO` a dizer que aqui entra o repositório
(Supabase + upload dos documentos já comprimidos) e que a interface não muda.

Regras de validação:

- **nome**: pelo menos 5 caracteres e conter um espaço.
  Erro: `Escreva o nome completo, como está no BI.`
- **telefone**: `^8[2-7]\d{7}$` depois de remover espaços.
  Erro: `Número de 9 dígitos, começado por 82 a 87.`
- **bairro**: pelo menos 3 caracteres.
  Erro: `Indique o bairro onde vive.`
- **categoria**: escolhida. Erro: `Escolha o serviço que presta.`
- **zonas**: pelo menos uma. Erro: `Escolha pelo menos uma zona onde atende.`
- **documentos**: foto de perfil e BI frente.
  Erro: `Faltam a foto de perfil e a frente do BI.`

---

## 7. Ecrã

`CadastroPrestadorEcra` (`ConsumerWidget`). Não guarda dados nem valida nada.

- `PopScope`: só deixa sair no primeiro passo; no resto, o botão do sistema
  recua um passo.
- `AppBar`: título `Registar-se como prestador`, vazio no passo de aprovação.
  Seta de voltar apenas nos passos 2 e 3.
- Corpo: `SafeArea(top: false)` + `LayoutBuilder` + `SingleChildScrollView`
  (padding lateral `margemEcra`, 8 no topo, 32 no fundo) + `Center` +
  `ConstrainedBox(maxWidth: larguraMaximaConteudo)`. Em tablet o formulário
  centra-se em vez de esticar para linhas de 900px.
- Transição entre passos: `AnimatedSwitcher` de 260 ms, `easeOutCubic`, com
  fade e deslocamento vertical de 0.03, chaveado pelo passo.
- `bottomNavigationBar`: `BarraAccoes`. Rótulo do botão: `Continuar` nos dois
  primeiros passos, `Enviar cadastro` nos documentos, `Concluir` na aprovação.
  Ícone de seta excepto no último. Antes de avançar, tira o foco do teclado.
  No passo dos documentos, botão de texto `Voltar` como acção secundária.

### Passo 1 — dados (`passo_dados.dart`)

`ConsumerStatefulWidget`, com os três `TextEditingController` criados no
`initState` a partir do estado (para os valores sobreviverem a ir e voltar) e
libertados no `dispose`.

Cabeçalho: título `Os seus dados`, apoio
`É por aqui que os clientes o contactam depois de o escolherem.`

Campos, com 20 de espaço entre eles:

1. `Nome completo`, dica `Como está no BI`, autofoco, teclado de nome.
2. `Número de telefone`, prefixo `+258`, dica `84 123 4567`, auxiliar
   `Use o número que atende durante o dia.`, teclado numérico, máximo 9,
   `FilteringTextInputFormatter.digitsOnly`.
3. `Bairro onde vive`, dica `Ex.: Malhangalene`, acção `done`.

### Passo 2 — categoria e zonas (`passo_categoria.dart`)

Título `O que faz e onde`, apoio
`Só recebe pedidos do serviço e das zonas que escolher aqui.`

Secção `Serviço que presta` (`titleSmall`): uma `LinhaOpcao` por categoria, 12
de espaço entre elas.

Secção `Zonas onde atende`, com contador à direita (`Nenhuma` ou
`N escolhidas`, este último na cor primária e a negrito): `Wrap` de
`FilterChip`, espaçamento 8 nos dois eixos.

Erros de categoria e de zonas aparecem por baixo da respectiva secção, num
widget privado com ícone `error_outline_rounded` de 16px e texto `bodySmall` na
cor de erro.

### Passo 3 — documentos (`passo_documentos.dart`)

Título `Documentos`, apoio `Confirmamos a sua identidade antes de o mostrar aos
clientes. Só a foto de perfil fica visível.`

Três `CartaoDocumento`, 12 de espaço:

1. `Foto de perfil` / `Rosto visível, sem óculos escuros` / `person_outline_rounded`
2. `BI, frente` / `Toda a página dentro da foto` / `badge_outlined`
3. `BI, verso (opcional)` / `Acelera a aprovação` / `badge_outlined`

Por baixo, o erro de documentos quando existir, e sempre uma nota com ícone
`lock_outline_rounded`: `Os documentos são vistos apenas pela equipa que aprova
os cadastros.`

A escolha de ficheiro é simulada (define um nome como `perfil.jpg`), com um
`TODO`: trocar por `image_picker` com compressão antes do upload, porque a
câmara devolve ficheiros de vários MB e a rede aqui não perdoa.

### Passo 4 — aprovação (`passo_aprovacao.dart`)

Sem cabeçalho de passo nem fita. Quadrado de 56px com fundo `primaryContainer`,
raio grande e `check_rounded` na primária. Título `Cadastro enviado`.

Texto: `Verificamos os seus documentos e ligamos-lhe para o +258 {telefone} até
dois dias úteis. Depois disso já pode definir os seus preços.`

Caixa com contorno (não cartão) e três linhas separadas por `Divider`, rótulo à
esquerda em `bodyMedium` e valor à direita em `titleSmall`: `Nome`, `Serviço`,
`Zonas` (as três primeiras e `+N` se houver mais).

O botão `Concluir` fica na barra de fundo, com um `TODO` para navegar ao painel
do prestador via GoRouter.

---

## 8. Voz da interface

- Tratamento por "você" implícito, sem "tu" e sem gerúndio brasileiro.
- Português europeu/moçambicano: "está a carregar", não "está carregando".
- Botões dizem o que acontece: `Enviar cadastro`, não `Submeter`.
- Erros explicam o que fazer, não pedem desculpa nem culpam o utilizador.
- Frases curtas. Nada de emojis a substituir ícones.

## 9. Aceitação

Depois de construir, correr `flutter analyze` (sem avisos) e verificar no
aparelho:

1. Continuar com tudo vazio no passo 1 mostra três erros.
2. `84123` no telefone é rejeitado; `841234567` passa.
3. Passo 2 não avança sem categoria e sem pelo menos uma zona.
4. Passo 3 não envia sem foto de perfil e BI frente.
5. Voltar do passo 3 ao 1 mantém tudo o que foi escrito.
6. A fita anima ao mudar de passo.
7. Em modo escuro do sistema, o ecrã continua legível.
8. Em paisagem, o conteúdo faz scroll sem cortes.
